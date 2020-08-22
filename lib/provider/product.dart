import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imgUrl;
  bool isFavourite;
  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imgUrl,
      this.isFavourite = false});

  void _setfav(bool newfav) {
    isFavourite = newfav;
    notifyListeners();
  }

  Future<void> togglefavouritestatus(String token, String userId) async {
    final oldstatus = isFavourite;
    final url =
        'https://shopping-3f634.firebaseio.com/userfavourites/$userId/$id.json?auth=$token';
    isFavourite = !isFavourite;
    try {
      var response = await http.put(url,
          body: json.encode(
            isFavourite,
          ));
      notifyListeners();
      if (response.statusCode >= 400) {
       _setfav(oldstatus);
      }
    } catch (error) {
      _setfav(oldstatus);
     // isFavourite = oldstatus;
     // notifyListeners();
    }
  }
}
