import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _info = "Informe seu peso e altura para serem calculados!";
  TextEditingController pesoController = TextEditingController();
  TextEditingController altController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void clearInfo(){
    setState((){
      pesoController.text = "";
      altController.text = "";
      _info = "Informe seu peso e altura para serem calculados!";
      _formKey = GlobalKey<FormState>();
    });
  }
  void calcular(){
    setState(() {
      double peso = double.parse(pesoController.text);
      double alt = double.parse(altController.text) / 100;
      double res = peso / (alt * alt);
      if(res < 18.6){
        _info = "Abaixo do peso. Imc de ${res.toStringAsPrecision(4)}";
      } else if (res >= 18.6 && res < 24.9){
        _info = "Peso ideal. Imc de ${res.toStringAsPrecision(4)}";
      } else if (res >= 24.9 && res < 29.9){
        _info = "Levemente acima do peso. Imc de ${res.toStringAsPrecision(4)}";
      } else if (res >= 29.9 && res < 34.9){
        _info = "Obesidade grau I. Imc de ${res.toStringAsPrecision(4)}";
      } else if (res >= 34.9 && res < 39.9){
        _info = "Obesidade grau II. Imc de ${res.toStringAsPrecision(4)}";
      } else if (res >= 39.9){
        _info = "Obesidade grau III. Imc de ${res.toStringAsPrecision(4)}";
      }
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {
            clearInfo();
          },)
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.person_outline, size: 120, color: Colors.green),
              TextFormField(keyboardType: TextInputType.number, decoration: InputDecoration(
                  labelText: "Peso (kg)",
                  labelStyle: TextStyle(color: Colors.green)
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25),
                controller: pesoController,
                validator: (value){
                  if(value.isEmpty){
                    return "Insira seu peso!";
                  }
                },
              ),
              TextFormField(keyboardType: TextInputType.number, decoration: InputDecoration(
                  labelText: "Altura (cm)",
                  labelStyle: TextStyle(color: Colors.green)
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25),
                controller: altController,
                validator: (value){
                  if(value.isEmpty){
                    return "Insira sua altura!";
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Container(
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()){
                        calcular();
                      }
                    },
                    child: Text("Calcular",
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                    color: Colors.green,
                  ),
                ),
              ),
              Text(_info, textAlign: TextAlign.center, style: TextStyle(fontSize: 25, color: Colors.green),)
            ],
          ),
        )
      )
    );
  }
}