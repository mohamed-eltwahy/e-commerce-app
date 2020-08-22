import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/products_provider.dart';

class ProductDetails extends StatelessWidget {
  static final id = 'ProductDetails';

  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context).settings.arguments;
    final loadedproducts = Provider.of<ProviderProducts>(context, listen: false)
        .findbyId(productid);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedproducts.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  loadedproducts.imgUrl,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${loadedproducts.price}',
                style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                
                  width: double.infinity,
                  child: Text(
                    loadedproducts.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 19),softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
