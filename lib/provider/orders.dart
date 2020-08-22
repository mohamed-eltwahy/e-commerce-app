import 'package:flutter/material.dart';
import 'package:shopping/provider/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> productsOrders;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.productsOrders,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> orderss = [];
  final String authtoken;
  final String userid;
  Orders({this.authtoken,this.orderss,this.userid});

  List<OrderItem> get orders {
    return orderss;
  }

  Future<void> getandsetorders() async {
    final url = 'https://shopping-3f634.firebaseio.com/orders/$userid.json?auth=$authtoken';
    var response = await http.get(url);
    List<OrderItem> loadedordersitems = [];
    var data = json.decode(response.body) as Map<String, dynamic>;
    if (data == null) {
      return;
    }
    data.forEach((orderid, orderdata) {
      loadedordersitems.add(OrderItem(
        id: orderid,
        amount: orderdata['amont'],
        dateTime: DateTime.parse(orderdata['dateTime']),
        productsOrders: (orderdata['products'] as List<dynamic>)
            .map( 
              (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  price: e['price'],
                  quantity: e['quantity']),
            )
            .toList(),
      ));
    });
    orderss = loadedordersitems.reversed.toList();
    notifyListeners();
  }

  Future<void> addorder(List<CartItem> products, double total) async {
    final url = 'https://shopping-3f634.firebaseio.com/orders/$userid.json?auth=$authtoken';
    var response = await http.post(url,
        body: json.encode({
          'amont': total,
          'dateTime': DateTime.now().toIso8601String(),
          'products': products
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        }));
    orderss.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: DateTime.now(),
        productsOrders: products,
      ),
    );
    notifyListeners();
  }
}
