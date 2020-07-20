import 'package:flutter/material.dart';
import 'package:oferta/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enviar Ofertas',
      theme: ThemeData(
        primaryColor: Color(0XFF2A2B2A),
        accentColor: Color(0XFFE4572E),
        primaryColorLight: Color(0XFFFDF9EA),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen()
    );
  }
}
