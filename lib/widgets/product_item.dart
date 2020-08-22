import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/auth.dart';
import 'package:shopping/provider/cart.dart';
import 'package:shopping/provider/product.dart';
import 'package:shopping/screens/products_details.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productdata = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final tokendata=Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetails.id, arguments: productdata.id);
          },
          child: Image.network(
            productdata.imgUrl,
            fit: BoxFit.fill,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(productdata.isFavourite
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                productdata.togglefavouritestatus(tokendata.token,tokendata.userid);
              }),
          title: Text(
            productdata.title,
            textAlign: TextAlign.center,
          ),
          trailing: 
            IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.additem(
                      productdata.id, productdata.price, productdata.title);
                      Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added item to Cart!'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(label: 'UNDO', onPressed: (){
                        cart.undo(productdata.id);
                      }),
                    ),
                  );
                }),
         
        ),
      ),
    );
  }
}
