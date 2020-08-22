import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/screens/edit_product.dart';
import '../provider/products_provider.dart';

class UserproductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgurl;
  UserproductItem(this.id, this.title, this.imgurl);
  @override
  Widget build(BuildContext context) {
    final scaffold=Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgurl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProduct.id, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                 await Provider.of<ProviderProducts>(context, listen: false)
                      .deleteproduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Deleting Failed!'),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
