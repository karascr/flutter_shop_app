import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = "/edit-product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var product =
      Product(id: "", title: "", description: "", imageUrl: "", price: 0);
  bool isInit = true;
  bool isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImagePreview);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final argument = ModalRoute.of(context)!.settings.arguments;
      final String productId = argument == null ? "" : argument as String;
      if (productId.isNotEmpty) {
        product = Provider.of<ProductsProvider>(context, listen: false)
            .getById(productId);
        _imageUrlController.text = product.imageUrl;
      }
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImagePreview);
    super.dispose();
  }

  void _updateImagePreview() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    bool? isValid = _formKey.currentState?.validate();
    if (!isValid!) return;
    _formKey.currentState?.save();
    setState(() {
      isLoading = true;
    });

    // print(product);
    final provider = Provider.of<ProductsProvider>(context, listen: false);
    if (product.id.isEmpty) {
      final isSuccess = await provider.addProduct(product);
      setState(() {
        isLoading = false;
      });
      if (isSuccess) {
        Navigator.of(context).pop();
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Text("An Error Occured!"),
            content: Text("Something went wrong. Please try again ."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text("Okay"))
            ],
          ),
        );
      }
    } else {
      await provider.updateProduct(product);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: product.title,
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) return "Please provide a value.";
                          return null;
                        },
                        onSaved: (value) {
                          product.title = value ?? "";
                        },
                      ),
                      TextFormField(
                        initialValue: product.price.toStringAsFixed(2),
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) return "Please provide a price.";
                          if (double.tryParse(value) == null)
                            return "Please enter a valid number";
                          if (double.parse(value) <= 0)
                            return "Please enter a number greater then zero.";
                          return null;
                        },
                        onSaved: (value) {
                          product.price = double.tryParse(value ?? "") ?? 0;
                        },
                      ),
                      TextFormField(
                        initialValue: product.description,
                        decoration: InputDecoration(labelText: "Description"),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descFocusNode,
                        validator: (value) {
                          if (value!.isEmpty)
                            return "Please enter a description.";
                          if (value.length < 10)
                            return "Should be at least 10 characters long";
                          return null;
                        },
                        onSaved: (value) {
                          product.description = value ?? "";
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: FittedBox(
                              child: _imageUrlController.text.isEmpty
                                  ? Text("Enter Url")
                                  : Image.network(_imageUrlController.text),
                            ),
                          ),
                          Expanded(
                              child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Please enter an image URL.";
                              if (!value.startsWith("http") &&
                                  !value.startsWith("https"))
                                return "Please enter a valid URL";
                              return null;
                            },
                            onSaved: (value) {
                              product.imageUrl = value ?? "";
                            },
                          )),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
