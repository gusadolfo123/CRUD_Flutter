import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/providers/products_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formkey = GlobalKey<FormState>();
  ProductModel product = ProductModel();
  final productProvider = new ProductProvider();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _saving = false;
  final imagePicker = ImagePicker();
  PickedFile photo;

  @override
  Widget build(BuildContext context) {
    final ProductModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) product = prodData;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Productos"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _selectPhoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takePhoto,
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
                _viewPhoto(),
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

  Widget _viewPhoto() {
    if (product.photoUrl != null && product.photoUrl != "") {
      return Container(
          child: FadeInImage(
        image: NetworkImage(product.photoUrl),
        placeholder: AssetImage("assets/img/jar-loading.gif"),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.cover,
      ));
    } else {
      return Image(
        image: AssetImage(photo?.path ?? "assets/img/no-image.png"),
      );
    }
  }

  _selectPhoto() async {
    _processImage(ImageSource.gallery);
  }

  _takePhoto() async {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource source) async {
    photo = await imagePicker.getImage(source: source);
    if (photo != null) {
      // limpieza
      product.photoUrl = null;
    }

    setState(() {});
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
      onPressed: (_saving) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formkey.currentState.validate()) return;

    // dispara el onSave de todos los tectFormField
    formkey.currentState.save();

    setState(() {
      _saving = true;
    });

    if (photo != null) {
      product.photoUrl = await productProvider.uploadImage(photo);
    }

    if (product.id == null)
      productProvider.createProduct(product);
    else
      productProvider.updateProduct(product);

    setState(() {
      _saving = false;
    });
    showSnackBar("Registro guardado");

    Navigator.pop(context);
  }

  void showSnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
