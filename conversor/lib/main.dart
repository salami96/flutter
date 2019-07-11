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
double dolar;
double euro;

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
                      TextField(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.amber),
                          labelText: "Reais",
                          border: OutlineInputBorder(),
                          prefixText: "R\$ "
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25)
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.amber),
                          labelText: "Dólares",
                          border: OutlineInputBorder(),
                          prefixText: "US\$ "
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25)
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.amber),
                          labelText: "Euros",
                          border: OutlineInputBorder(),
                          prefixText: "€ "
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25)
                      ),
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