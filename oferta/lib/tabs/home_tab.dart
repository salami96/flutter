import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:dio/dio.dart';
String url = 'http://api.supercopac.com.br/api/';


class HomeTab extends StatelessWidget {

  Future<Map> get() async {
    try {
      Response response = await Dio().get(
        url + "contatos",
        options: Options(headers: {'access_key': 't5b3b9a5'})
      );
      return response.data;
    } catch (e) {
      print(e);
    }
  }
  Future<Map> delete(id) async {
    try {
      Response response = await Dio().get(
        url + "contato/" + id
      );
      print(response.data);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    Color primary = Theme.of(context).primaryColor;
    Color accent = Theme.of(context).accentColor;
    Color light = Theme.of(context).primaryColorLight;

    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ light, Colors.white ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        )
      ),
    );

    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: <Widget>[
                IconButton(icon: Icon(Icons.search, color: light,), onPressed: (){})
              ],
              floating: true,
              snap: true,
              backgroundColor: primary,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Clientes"),
                centerTitle: true
              ),
            ),
            FutureBuilder<Map>(
              future: get(),
              builder: (context, snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return SliverToBoxAdapter(
                      child: Card(
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Row(
                            children: <Widget>[
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[700])
                              ),
                              Expanded(child: Text("Carregando...", textAlign: TextAlign.center,))
                            ],
                          )
                        )
                      ),
                    );
                  break;
                  default:
                    if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Card(
                          margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.error_outline, color: accent, size: 40,),
                                Expanded(child: Text("Ocorreu um erro...", textAlign: TextAlign.center,))
                              ],
                            )
                          )
                        ),
                      );
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index){
                            return _contactCard(context, index, snapshot.data['contatos']);
                          },
                        ),
                      );
                    }
                  break;
                }
              },
            )
          ],
        )
      ],
    );
  }

  Widget _contactCard(context, index, contacts) {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                contacts[index]['nome'] ?? "",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                contacts[index]['numero'] ?? "",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        _showOptions(context, index, contacts);
      },
    );
  }

  _showOptions(context, index, contacts){
    var number = contacts[index]['numero'];
    var id = contacts[index]['count'];
    showModalBottomSheet(
      context: context,
      builder: (context){
        return BottomSheet(
          builder: (context){
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FlatButton(
                      child: Text(
                        "Ligar",
                        style: TextStyle(color: Colors.green, fontSize: 20),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        launch("tel:$number");
                      },
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FlatButton(
                      child: Text(
                        "WhatsApp",
                        style: TextStyle(color: Colors.green, fontSize: 20),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        if (number.length == 9) {
                          launch("https://wa.me/5551$number");
                        } else {
                          launch("https://wa.me/55$number");
                        }
                      },
                    )
                  ),
                  /* Padding(
                    padding: EdgeInsets.all(5),
                    child: FlatButton(
                      child: Text(
                        "Editar",
                        style: TextStyle(color: green, fontSize: 20),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        _showContactPage(c: contacts[index]);
                      },
                    )
                  ), */
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FlatButton(
                      child: Text(
                        "Excluir",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                      onPressed: () {
                        // var resp = await delete(id);
                        print(id + 'Excuindo...');
                        /* final snackBar = SnackBar(
                          content: Text(id),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                        helper.deleteContact(contacts[index].id);
                        setState((){
                          contacts.removeAt(index);
                        }); */

                        Navigator.pop(context);
                      },
                    )
                  ),
                ],
              ),
            );
          },
          onClosing: (){},
        );
      }
    );
  }

}