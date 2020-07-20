import 'package:flutter/material.dart';
import 'package:loja/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {
  final VoidCallback buy;

  CartPrice(this.buy);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        padding: EdgeInsets.all(16),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            String price = model
                .getProductsPrice()
                .toStringAsFixed(2)
                .replaceAll(".", ",");
            String discount =
                model.getDiscount().toStringAsFixed(2).replaceAll(".", ",");
            String ship =
                model.shipValue.toStringAsFixed(2).replaceAll(".", ",");
            String total = (model.getProductsPrice() -
                    model.getDiscount() +
                    model.shipValue)
                .toStringAsFixed(2)
                .replaceAll(".", ",");

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Resumo do Pedido",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text("Subtotal"), Text("R\$ $price")],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text("Desconto"), Text("R\$ -$discount")],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text("Frete"), Text("R\$ $ship")],
                ),
                Divider(),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "R\$ $total",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 16),
                    )
                  ],
                ),
                SizedBox(height: 12),
                RaisedButton(
                  onPressed: buy,
                  child: Text("Finalizar Pedido"),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
