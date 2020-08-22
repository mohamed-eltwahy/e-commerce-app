import 'package:flutter/material.dart';
import 'package:shopping/provider/cart.dart';
import 'package:shopping/provider/orders.dart';
import 'package:shopping/screens/cart_screen.dart';
import 'package:shopping/screens/edit_product.dart';
import 'package:shopping/screens/splash_screen.dart.dart';
import 'package:shopping/screens/userProduct_screen.dart';
import './screens/products_overview.dart';
import './screens/products_details.dart';
import './provider/products_provider.dart';
import 'package:provider/provider.dart';
import './screens/orders_screen.dart';
import 'screens/auth_screen.dart.dart';
import './provider/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProviderProducts>(
          create: (context) => ProviderProducts(),
          update: (context, Auth auth, ProviderProducts previous) =>
              ProviderProducts(
                  authtoken: auth.token,
                  userId: auth.userid,
                  iitems: previous.items == null ? [] : previous.items),
        ),
        ChangeNotifierProvider<Cart>(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (context, Auth auth, Orders previous) => Orders(
              authtoken: auth.token,
              userid: auth.userid,
              orderss: previous.orders == null ? [] : previous.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isauth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.autologin(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                ),
          // ProductsOverviewScreen(),
          // initialRoute: ProductsOverviewScreen.id,
          routes: {
            ProductsOverviewScreen.id: (context) => ProductsOverviewScreen(),
            ProductDetails.id: (context) => ProductDetails(),
            CartScreen.id: (context) => CartScreen(),
            OrdersScreen.id: (context) => OrdersScreen(),
            UserProducts.id: (context) => UserProducts(),
            EditProduct.id: (context) => EditProduct(),
            // AuthScreen.id:(context)=>AuthScreen(),
          },
        ),
      ),
    );
  }
}
