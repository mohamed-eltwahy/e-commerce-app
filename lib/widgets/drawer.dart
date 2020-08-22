import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/provider/auth.dart';
import 'package:shopping/screens/orders_screen.dart';
import 'package:shopping/screens/userProduct_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
              title: Text(
                'hello friend!'.toUpperCase(),
              ),
             automaticallyImplyLeading: false
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('shop'),
                onTap: ()
                {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Orders'),
                onTap: ()
                {
                  Navigator.of(context).pushReplacementNamed(OrdersScreen.id);
                },
              ),
               Divider(),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Manage products'),
                onTap: ()
                {
                  Navigator.of(context).pushReplacementNamed(UserProducts.id);
                },
              ),
               Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: ()
                {
                  Navigator.of(context).pop();
                   Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context,listen: false).logout();
                },
              ),
        ],
      ),
    );
  }
}
