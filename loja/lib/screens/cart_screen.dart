import 'package:flutter/material.dart';
import 'package:loja/models/cart_model.dart';
import 'package:loja/models/user_model.dart';
import 'package:loja/screens/login_screen.dart';
import 'package:loja/screens/order_screen.dart';
import 'package:loja/tiles/cart_tile.dart';
import 'package:loja/widgets/cart_price.dart';
import 'package:loja/widgets/discount_card.dart';
import 'package:loja/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CartModel>(builder: (context, child, model) {
      int p = model.products.length;
      return Scaffold(
          appBar: AppBar(
            title: Text("Meu Carrinho"),
            centerTitle: true,
            actions: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  "${p ?? 0} ${p == 1 ? "item" : "itens"}",
                  style: TextStyle(fontSize: 17),
                ),
              )
            ],
          ),
          body: Builder(builder: (context) {
            if (model.isLoading && UserModel.of(context).isLoggedIn()) {
              return Center(child: CircularProgressIndicator());
            } else if (!UserModel.of(context).isLoggedIn()) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add_shopping_cart,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Entre para adicionar ou ver os produtos!",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      child: Text("Entrar", style: TextStyle(fontSize: 18)),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              );
            } else if (model.products == null || model.products.length == 0) {
              return Center(
                  child: Text("Nenhum produto no carrinho!",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)));
            } else {
              return ListView(
                children: <Widget>[
                  Column(
                    children: model.products.map((product) {
                      return CartTile(product);
                    }).toList(),
                  ),
                  DiscountCard(),
                  ShipCard(),
                  CartPrice(() async {
                    String orderId = await model.finishOrder();

                    if (orderId != null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => OrderScreen(orderId)));
                    }
                  }),
                ],
              );
            }
          }));
    });
  }
}
