import 'package:flutter/material.dart';
import 'package:shopping/models/exceptions.dart';
import 'package:shopping/provider/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProviderProducts with ChangeNotifier {
  List<Product> iitems = [
    // Product(
    //   id: 'id1',
    //   title: 'Sweatshirt',
    //   price: 22,
    //   description:
    //       'BLACK Color Block Letter V Splicing Round Neck Long Sleeve Slimming Modish Polyester Sweatshirt For Men Polyester',
    //   imgUrl:
    //       'https://www.events5s.sk/images/image/BLACK%20Color%20Block%20Letter%20V%20Splicing%20Round%20Neck%20Long%20Sleeve%20Slimming%20Modish%20Polyester%20Sweatshirt%20For%20Men%20Polyester%20Full%20145515320.jpg',
    // ),
    // Product(
    //     id: 'id2',
    //     title: 'trouser',
    //     description: 'blue black trouser',
    //     price: 22.6,
    //     imgUrl:
    //         'https://www.next.co.uk/nxtcms/resource/image/2766426/portrait_ratio2x3/320/480/ac7f34143b29dc9938736f5f64d2fdc3/Fw/jeanstrousers.jpg'),
    // Product(
    //     id: 'id3',
    //     title: 'Sweatshirt',
    //     description: 'grey Sweatshirt',
    //     price: 30,
    //     imgUrl:
    //         'https://images-na.ssl-images-amazon.com/images/I/617utyqPF0L._AC_UX522_.jpg'),
    // Product(
    //     id: 'id4',
    //     title: 'red sweater',
    //     price: 180,
    //     description: 'sweater red, fall autumn clothing',
    //     imgUrl:
    //         'https://www.pngitem.com/pimgs/m/136-1369689_sweater-red-fall-autumn-clothing-png-polyvore-get.png'),
  ];
  // var showfavouritesOnly=false;

  List<Product> get items {
    // if(showfavouritesOnly)
    // {
    //   return _items.where((element) => element.isFavourite);
    // }
    return iitems;
  }

  List<Product> get favourites {
    return iitems.where((element) => element.isFavourite).toList();
  }

  Product findbyId(String id) {
    return items.firstWhere((element) => element.id == id);
  }
  // void showFavoritesOnly()
  // {
  //   showfavouritesOnly=true;
  //   notifyListeners();

  // }
  //void showAll()
  // {
  //   showfavouritesOnly=false;
  //   notifyListeners();
  // }

  final String authtoken;
  final String userId;

  ProviderProducts({this.authtoken, this.iitems, this.userId});

  Future<void> getallproducts([bool filter = false]) async {
    final filterstring =
        filter ? 'orderBy="usercreator"&equalTo="$userId"' : '';
    final url =
        'https://shopping-3f634.firebaseio.com/products.json?auth=$authtoken&$filterstring';
    try {
      var response = await http.get(url);
      var data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      final urlfavourite =
          'https://shopping-3f634.firebaseio.com/userfavourites/$userId.json?auth=$authtoken';

      final favresponse = await http.get(urlfavourite);
      final favdata = json.decode(favresponse.body);

      List<Product> loadeddata = [];
      data.forEach((prodId, prodData) {
        loadeddata.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imgUrl: prodData['imgeurl'],
            price: prodData['price'],
            isFavourite: favdata == null ? false : favdata[prodData] ?? false));
      });
      iitems = loadeddata;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopping-3f634.firebaseio.com/products.json?auth=$authtoken';
    try {
      var response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'imgeurl': product.imgUrl,
            'description': product.imgUrl,
            'price': product.price,
            'usercreator': userId,
          }));
      final newproduct = Product(
          description: product.description,
          id: json.decode(response.body)['name'],
          title: product.title,
          imgUrl: product.imgUrl,
          price: product.price);
      iitems.add(newproduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateprod(String id, Product newproduct) async {
    final prodindex = iitems.indexWhere((element) => element.id == id);
    if (prodindex >= 0) {
      final url =
          'https://shopping-3f634.firebaseio.com/products/$id.json?auth=$authtoken';
      await http.patch(url,
          body: json.encode({
            'title': newproduct.title,
            'price': newproduct.price,
            'description': newproduct.description,
            'imageUrl': newproduct.imgUrl,
          }));

      iitems[prodindex] = newproduct;
      notifyListeners();
    }
   
  }

  Future<void> deleteproduct(String id) async {
    final url =
        'https://shopping-3f634.firebaseio.com/products/$id.json?auth=$authtoken';
    final existingindex = iitems.indexWhere((element) => element.id == id);
    var existingproduct = iitems[existingindex];

    iitems.removeAt(existingindex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      iitems.insert(existingindex, existingproduct);
      notifyListeners();
      throw HttpException('could not delete this product');
    }
    existingproduct = null;
  }
}
