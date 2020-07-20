import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  border: UnderlineInputBorder(), hintText: "Digite seu cupom"),
              initialValue: CartModel.of(context).cupomCode ?? "",
              onFieldSubmitted: (text) {
                Firestore.instance.collection("coupons").document(text).get().then((doc) {
                  if (doc.data != null) {
                    CartModel.of(context).setCupom(text, doc.data["percent"]);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Denconto de ${doc.data["percent"]}% aplicado 😀"),
                        backgroundColor: Theme.of(context).primaryColor,
                      )
                    );
                  } else {
                    CartModel.of(context).setCupom(null, 0);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Cupom Inválido 🙁"),
                        backgroundColor: Colors.redAccent,
                      )
                    );
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
