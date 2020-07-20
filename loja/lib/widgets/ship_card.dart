import 'package:flutter/material.dart';
import 'package:loja/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ShipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          "Definir Entrega",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.location_on),
        children: <Widget>[
          ScopedModelDescendant<CartModel>(builder: (context, child, model) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () => model.setShip(false),
                        child: Text("Buscar na loja"),
                        color: !model.needShipment
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        textColor: model.needShipment
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                      Container(width: 5),
                      RaisedButton(
                          onPressed: () => model.setShip(true),
                          child: Text("Tele-Entrega"),
                          color: model.needShipment
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          textColor: !model.needShipment
                              ? Theme.of(context).primaryColor
                              : Colors.white)
                    ],
                  ),
                  Container(height: 10),
                  Text(model.needShipment ? "Definir Endereço" : "Av. Cruz de Malta, 705")
                ]
              ),
            );
          })
        ],
      ),
    );
  }
}
