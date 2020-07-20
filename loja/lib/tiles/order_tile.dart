import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection("orders")
                    .document(orderId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    int status = snapshot.data["status"];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Código do pedido: ${snapshot.data.documentID}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          _buildProductsText(snapshot.data),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text("Status do Pedido:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildCircle(Icons.assignment, "Separação", status, 1),
                            Container(
                              height: 1,
                              width: 40,
                              color: Colors.grey,
                            ),
                            _buildCircle(Icons.local_shipping, "Transporte", status, 2),
                            Container(
                              height: 1,
                              width: 40,
                              color: Colors.grey,
                            ),
                            _buildCircle(Icons.mood, "Entrega", status, 3)
                          ],
                        )
                      ],
                    );
                  }
                })));
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = "Descrição:\n";

    for (LinkedHashMap p in snapshot.data["products"]) {
      text +=
          "${p["quantity"]} x ${p["product"]["title"]} (R\$ ${p["product"]["price"].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.data["total"].toStringAsFixed(2)}";
    return text;
  }

  Widget _buildCircle(
      IconData icon, String subtitle, int status, int thisStatus) {
    Color bgColor;
    Widget child;

    if (status < thisStatus) {
      bgColor = Colors.grey[500];
      child = Icon(icon, color: Colors.white);
    } else if (status == thisStatus) {
      bgColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Icon(icon, color: Colors.white),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      bgColor = Colors.green;
      child = Icon(Icons.check, color: Colors.white,);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20,
          child: child,
          backgroundColor: bgColor,
        ),
        Text(subtitle)
      ],
    );
  }
}
