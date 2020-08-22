import 'package:flutter/material.dart';
import '../provider/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;
  OrderItem({this.orderItem});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var expand = false;
  @override
  Widget build(BuildContext context) {
    //final order=Provider.of<Orders>(context);
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.dateTime),
            ),
            trailing: IconButton(
                icon: (expand)
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    expand = !expand;
                  });
                }),
          ),
          if (expand)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height:
                //MediaQuery.of(context).size.height,
                    min(widget.orderItem.productsOrders.length * 20.0 + 10, 180),
                child: ListView(
                  children: widget.orderItem.productsOrders
                      .map(
                        (e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              e.title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${e.quantity}x \$${e.price}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
