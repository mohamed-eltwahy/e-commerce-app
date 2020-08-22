import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/product.dart';
import 'package:shopping/provider/products_provider.dart';

class EditProduct extends StatefulWidget {
  static final id = 'editproduct';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _focusnode = FocusNode();
  final _descfocusnode = FocusNode();
  final _imageurlcontoller = TextEditingController();
  final _imagefocusnode = FocusNode();
  final _key = GlobalKey<FormState>();
  var editedproduct =
      Product(id: null, description: "", imgUrl: "", price: null, title: " ");

  @override
  void dispose() {
    _imagefocusnode.removeListener(updateimgurl);
    _focusnode.dispose();
    _descfocusnode.dispose();
    _imageurlcontoller.dispose();
    _imagefocusnode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _imagefocusnode.addListener(updateimgurl);

    super.initState();
  }

  var _initvalues = {
    'title': '',
    'description': '',
    'price': '',
    'imgurl': '',
  };
  var _isinit = true;
  bool _isloading = false;

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final editedproduct =
            Provider.of<ProviderProducts>(context, listen: false)
                .findbyId(productId);
        _initvalues = {
          'title': editedproduct.title,
          'description': editedproduct.description,
          'price': editedproduct.price.toString(),
          'imgurl': '',
        };
        _imageurlcontoller.text = editedproduct.imgUrl;
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  void updateimgurl() {
    if (!_imagefocusnode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveform() async {
    final isvalid = _key.currentState.validate();
    if (!isvalid) {
      return;
    }
    _key.currentState.save();
    setState(() {
      _isloading = true;
    });

    if (editedproduct.id != null) {
      await Provider.of<ProviderProducts>(context, listen: false)
          .updateprod(editedproduct.id, editedproduct);
    } else {
      try {
        await Provider.of<ProviderProducts>(context, listen: false)
            .addProduct(editedproduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('an error occured!'),
                  content: Text('something went wrong'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                ));
      }
      setState(() {
        _isloading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'.toUpperCase()),
        actions: <Widget>[
          FlatButton(
            onPressed: _saveform,
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _key,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initvalues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_focusnode);
                      },
                      onSaved: (value) {
                        editedproduct = Product(
                          title: value,
                          price: editedproduct.price,
                          description: editedproduct.description,
                          imgUrl: editedproduct.imgUrl,
                          id: editedproduct.id,
                          isFavourite: editedproduct.isFavourite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'enter a valid input';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initvalues['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _focusnode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descfocusnode);
                      },
                      onSaved: (value) {
                        editedproduct = Product(
                          title: editedproduct.title,
                          price: double.parse(value),
                          description: editedproduct.description,
                          imgUrl: editedproduct.imgUrl,
                          id: editedproduct.id,
                          isFavourite: editedproduct.isFavourite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'enter a number greater than zero';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initvalues['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descfocusnode,
                      onSaved: (value) {
                        editedproduct = Product(
                          title: editedproduct.title,
                          price: editedproduct.price,
                          description: value,
                          imgUrl: editedproduct.imgUrl,
                          id: editedproduct.id,
                          isFavourite: editedproduct.isFavourite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'enter a description';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageurlcontoller.text.isEmpty
                              ? Text('Enter Url')
                              : FittedBox(
                                  child: Image.network(_imageurlcontoller.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageurlcontoller,
                            focusNode: _imagefocusnode,
                            onFieldSubmitted: (_) => _saveform(),
                            onSaved: (value) {
                              editedproduct = Product(
                                title: editedproduct.title,
                                price: editedproduct.price,
                                description: editedproduct.description,
                                imgUrl: value,
                                id: editedproduct.id,
                                isFavourite: editedproduct.isFavourite,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'enter an image url';
                              }
                              if (!value.startsWith('htttp') &&
                                  !value.startsWith('https')) {
                                return 'please enter a valid url';
                              }
                              if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.png') &&
                                  !value.endsWith('.jpeg')) {
                                return 'please enter a valid url';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
