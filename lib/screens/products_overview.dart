import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/cart.dart';
import 'package:shopping/screens/cart_screen.dart';
import 'package:shopping/widgets/badge.dart';
import 'package:shopping/widgets/drawer.dart';
import '../provider/products_provider.dart';

import 'package:shopping/widgets/product_grid.dart';

enum FilterOption {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static final id = 'ProductsOverviewScreen';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showfavouritesOnly = false;
  bool _isinit = true;
  bool _isloading = false;
  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<ProviderProducts>(context)
          .getallproducts()
          .then((_) => setState(() {
                _isloading = false;
              }));
    }

    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my shop'.toUpperCase()),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOption value) {
                setState(() {
                  switch (value) {
                    case FilterOption.All:
                      showfavouritesOnly = false;
                      break;
                    case FilterOption.Favourites:
                      showfavouritesOnly = true;
                      break;
                  }
                });
              },
              icon: Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Only Favourites'),
                      value: FilterOption.Favourites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOption.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (context, cart, child) => Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.id);
                },
              ),
              value: cart.itemcount.toString(),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showfavouritesOnly),
    );
  }
}
