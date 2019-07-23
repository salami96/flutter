import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {

  final Map _gifData;
  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rule34"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share), 
            color: Colors.white,
            onPressed: (){
              Share.share(_gifData["file_url"]);
            },
          )
        ],
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData["file_url"]),
      ),
      
    );
  }
}