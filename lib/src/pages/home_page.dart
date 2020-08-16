import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/providers/products_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productProvider = new ProductProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: _createListProducts(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, "product").then((value) {
          setState(() {});
        }),
      ),
    );
  }

  Widget _createItem(BuildContext context, ProductModel product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        productProvider.deleteProduct(product.id);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            (product.photoUrl == null || product.photoUrl == "")
                ? Image(image: AssetImage("assets/img/no-image.png"))
                : FadeInImage(
                    image: NetworkImage(product.photoUrl),
                    placeholder: AssetImage("assets/img/jar-loading.gif"),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text("${product.title} - ${product.value}"),
              subtitle: Text(product.id),
              onTap: () =>
                  Navigator.pushNamed(context, "product", arguments: product)
                      .then((value) {
                setState(() {});
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget _createListProducts() {
    print("entro");
    return FutureBuilder(
      future: productProvider.getAllProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) =>
                _createItem(context, products[index]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
