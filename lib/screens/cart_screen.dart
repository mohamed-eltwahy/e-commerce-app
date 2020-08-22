import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../provider/orders.dart';

class CartScreen extends StatefulWidget {
  static String id = 'cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isloading=false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('your cart'.toUpperCase()),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  FlatButton(
                    onPressed: (cart.totalAmount <= 0 || _isloading)
                        ? null
                        : () async {
                          setState(() {
                            _isloading=true;
                          });
                        await order.addorder(
                                cart.items.values.toList(), cart.totalAmount);
                                setState(() {
                            _isloading=false;
                          });
                            cart.clear();
                          },
                    child: _isloading?CircularProgressIndicator(): Text(
                      'order now'.toUpperCase(),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemcount,
              itemBuilder: (context, index) => CartItem(
                  cart.items.values.toList()[index].id,
                  cart.items.values.toList()[index].title,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].price),
            ),
          ),
        ],
      ),
    );
  }
}
