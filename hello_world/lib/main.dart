import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "contador de pessoas",
    home: Home()
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _people = 0;
  String _info = "Pode entrar!";

  void _changePeople(int delta){
    setState(() {
      if(_people >= 35 && delta == 1){
        _info = "lotação esgotada!";
      } else if (_people > 0 && delta == -1){
        _info = "Pode entrar!";
        _people--;
      } else if (_people < 10 && _people >= 0 && delta == 1){
        _people++;
        _info = "Pode entrar!";
      } else if (_people == 0 && delta == -1){
        _info = "Não tem mais ninguém pra sair";
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1000,

        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Pessoas: $_people", 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text(
                      "+1", 
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {
                     _changePeople(1);
                    }
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text(
                      "-1",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {
                      _changePeople(-1);
                    }
                  ),
                ),
              ],
            ),
            Text(
              _info, 
              style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 20.0),
            )
          ],
        ),
      ],
    );
  }
}