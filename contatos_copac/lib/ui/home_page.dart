import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'package:contatos_copac/helpers/contact_helper.dart';
import 'contact_page.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  Color green = Color(0xff28A745);

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list){
      setState(() {
       contacts = list; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos Copac"),
        backgroundColor: green,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            icon: Icon(Icons.sort_by_alpha),
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Color(0xffdddddd),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: green,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contacts.length,
        itemBuilder: (context, index){
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(context, index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: 
                    contacts[index].image != "imgtest" &&
                    contacts[index].image != null ? 
                    FileImage(File(contacts[index].image)) :
                    AssetImage("images/person.png"),
                    fit: BoxFit.cover
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? "",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],  
          ),
          ),
      ),
      onTap: (){
        _showOptions(context, index);
      },
    );
  }

  _showOptions(context, index){
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
                        style: TextStyle(color: green, fontSize: 20),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        launch("tel:${contacts[index].phone}");
                      },
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FlatButton(
                      child: Text(
                        "WhatsApp",
                        style: TextStyle(color: green, fontSize: 20),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        launch("https://wa.me/55${contacts[index].phone}");
                      },
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FlatButton(
                      child: Text(
                        "Email",
                        style: TextStyle(color: green, fontSize: 20),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        launch("mailto:${contacts[index].email}");
                      },
                    )
                  ),
                  Padding(
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
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FlatButton(
                      child: Text(
                        "Excluir",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                      onPressed: (){
                        helper.deleteContact(contacts[index].id);
                        setState((){
                          contacts.removeAt(index);
                        });
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

  Future _showContactPage({Contact c}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: c,))
    );
    if (recContact != null) {
      if (c !=null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        contacts.sort((a,b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a,b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {
      
    });
  }

}