import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flare',
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: Text("Flare"), centerTitle: true
    ),
    body: Center(
      child: Container(
        width: 100,
        height: 100,
        /* decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.amber)
        ), */
        child: FlareActor("assets/Heart.flr", animation: "Untitled",),
      ),
    )
    );
  }
}
