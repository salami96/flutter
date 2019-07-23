import 'package:contatos_copac/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

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
        title: Text("Agenda Copac"),
        backgroundColor: green,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
        backgroundColor: green,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index){

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
                  image: DecorationImage(image: )
                ),
              )
            ],  
          ),
          ),
      ),
    )
  }

}