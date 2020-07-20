import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja/datas/product_data.dart';
import 'package:loja/tiles/product_tile.dart';
import 'package:loja/widgets/cart_button.dart';

class ProductsScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  ProductsScreen(this.snapshot);



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data["title"]),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.grid_on),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        floatingActionButton: CartButton(),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("products").document(snapshot.documentID).collection("items").getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.65
                    ),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (constext, index){
                      ProductData product = ProductData.fromDocument(snapshot.data.documents[index]);
                      product.category = this.snapshot.documentID;
                      return ProductTile("grid", product);
                    },
                    padding: EdgeInsets.all(4),
                  ),
                  ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (constext, index){
                      ProductData product = ProductData.fromDocument(snapshot.data.documents[index]);
                      product.category = this.snapshot.documentID;
                      return ProductTile("list", product);
                    },
                    padding: EdgeInsets.all(4),
                  )
                ],
              );
          }
        )
      ),
    );
  }
}
