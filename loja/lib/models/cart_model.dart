import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja/datas/cart_product.dart';
import 'package:loja/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  List<CartProduct> products = [];

  UserModel user;

  bool isLoading = false;

  String cupomCode;
  int discountPercentage = 0;
  bool needShipment = false;
  double shipValue = 0;

  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
      print(cartProduct.toMap());
      print(doc.documentID);
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    products.remove(cartProduct);

    Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .delete();

    notifyListeners();
  }

  void decCartItem(CartProduct cartProduct) {
    cartProduct.quantity--;

    Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incCartItem(CartProduct cartProduct) {
    cartProduct.quantity++;

    Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void setCupom(String cupom, int percent) {
    this.cupomCode = cupom;
    this.discountPercentage = percent;
    notifyListeners();
  }

  void setShip(bool value) {
    this.needShipment = value;
    this.shipValue = value ? 5 : 0;
    notifyListeners();
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    DocumentReference ref = await Firestore.instance.collection("orders").add({
      "clientId": user.firebaseUser.uid,
      "products": products.map((p) => p.toMap()).toList(),
      "shipPrice": shipValue,
      "productsPrice": getProductsPrice(),
      "discount": getDiscount(),
      "total": shipValue + getProductsPrice() - getDiscount(),
      "status": 1
    });

    await Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("orders")
        .document(ref.documentID)
        .setData({"orderId": ref.documentID});

    QuerySnapshot query = await Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }

    products.clear();

    discountPercentage = 0;
    cupomCode = null;
    shipValue = 0;
    needShipment = false;

    isLoading = false;
    notifyListeners();

    return ref.documentID;
  }

  _loadCartItems() async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    products =
        snapshot.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }
}
