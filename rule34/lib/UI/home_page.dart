import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';
import 'gif_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;
  int _offset;

  Future<List> _getGifs() async {
    http.Response response;

    if (_search == null || _search.isEmpty)
      response = await http.get("https://r34-json-api.herokuapp.com/posts?limit=20&tags=animated");
    else
      response = await http.get("https://r34-json-api.herokuapp.com/posts?limit=19&tags=$_search&pid=$_offset");

    return json.decode(response.body);
  }
  
  @override
  void initState() {
    super.initState();
    _getGifs().then((map){
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://rule34.xxx/images/topb.png"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search query...",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            )
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      )
                    );
                  default:
                    if (snapshot.hasError) return Container();
                    else return _createGifTable(context, snapshot);
                }
              }
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data){
    if(_search == null || _search.isEmpty){
      return data.length;
    } else {
      return data.length +1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10
      ),
      itemCount: _getCount(snapshot.data),
      itemBuilder: (context, index) {
        if (_search == null || _search.isEmpty || index < snapshot.data.length){
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              image: snapshot.data[index]["preview_url"],
              height: 300,
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GifPage(snapshot.data[index]) 
                )
              );
            },
            onLongPress: () {
              Share.share(snapshot.data[index]["file_url"]);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, size: 70, color: Colors.white,),
                  Text("Load more GIFs", style: TextStyle(fontSize: 22, color: Colors.white),)
                ],
              ),
              onTap: (){
                setState(() {
                 _offset += 1; 
                });
              },
            )
          );
        }
      },
    );
  }
}