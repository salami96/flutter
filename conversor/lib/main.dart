import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
const request = "http://api.hgbrasil.com/finance?format=json&key=870b72da";


void main() async {
  print(await getData());
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
    )
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body); 
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  
  double dolar;
  double euro;

  void _realChanged(String text){
    _clearAll(text);
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(3);
    euroController.text = (real/euro).toStringAsFixed(3);
  }
  void _dolarChanged(String text){
    _clearAll(text);
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(3);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(3);
  }
  void _euroChanged(String text){
    _clearAll(text);
    double euro = double.parse(text);
    dolarController.text = (euro * this.euro /dolar).toStringAsFixed(3);
    realController.text = (euro * this.euro).toStringAsFixed(3);
  }
  void _clearAll(String text){
    if(text.isEmpty) {
      realController.text = "";
      dolarController.text = "";
      euroController.text = "";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("C0NV3\$0R"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25),
                  textAlign: TextAlign.center,)
                  );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text("Erro ao carregar dados...",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25
                    ),
                  textAlign: TextAlign.center,)
                  );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150, color: Colors.amber),
                      buildTextField("Reais", "R\$ ", realController, _realChanged),
                      Divider(),
                      buildTextField("Dólares", "US\$ ", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("Euros", "€ ", euroController, _euroChanged),
                    ]
                  ),
                );
              }      
          }
        }
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function f){
  return TextField(
    decoration: InputDecoration(
      labelStyle: TextStyle(color: Colors.amber),
      labelText: label,
      border: OutlineInputBorder(),
      prefixText: prefix
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    controller: controller,
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}