import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final String prodID;
  final int quantity;
  final double price;
  CartItem(this.id, this.title, this.prodID, this.quantity, this.price);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove this item?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('NO')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('YES')),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).remove(prodID);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('\$$price'),
              )),
            ),
            title: Text(title),
            subtitle: Text('\$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
