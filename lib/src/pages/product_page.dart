import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/providers/products_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formkey = GlobalKey<FormState>();
  final product = ProductModel();
  final productProvider = new ProductProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                _createName(),
                _createPrice(),
                _createInStock(context),
                SizedBox(height: 20.0),
                _createButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createInStock(BuildContext context) {
    return SwitchListTile(
      value: product.inStock,
      title: Text("Disponible"),
      activeColor: Theme.of(context).primaryColor,
      onChanged: (value) {
        setState(() {
          product.inStock = value;
        });
      },
    );
  }

  Widget _createName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: "Producto"),
      onSaved: (newValue) => product.title = newValue,
      validator: (value) {
        if (value.length < 3) return "Ingrese Nombre de producto";
        return null;
      },
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: "Precio"),
      onSaved: (newValue) => product.value = double.parse(newValue),
      validator: (value) {
        if (!utils.isNumeric(value)) return "Ingrese un Numero Valido";
        return null;
      },
    );
  }

  Widget _createButton(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      label: Text("Guardar"),
      icon: Icon(Icons.save),
      onPressed: _submit,
    );
  }

  void _submit() {
    if (!formkey.currentState.validate()) return;

    // dispara el onSave de todos los tectFormField
    formkey.currentState.save();

    print("ok");
    print(product.title);
    print(product.value);
    print(product.inStock);

    productProvider.createProduct(product);
  }
}
