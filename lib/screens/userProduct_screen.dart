import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/screens/edit_product.dart';
import 'package:shopping/widgets/drawer.dart';
import 'package:shopping/widgets/userProduct_item.dart';
import '../provider/products_provider.dart';

class UserProducts extends StatelessWidget {
  static final id = 'userproducts';
  Future<void> _refresh(BuildContext context) async {
    await Provider.of<ProviderProducts>(context,listen: false).getallproducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final products =
    //     Provider.of<ProviderProducts>(context, listen: false).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('your products'.toUpperCase()),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProduct.id);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refresh(context),
        builder: ( context,snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refresh(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<ProviderProducts>(
                        builder: (ctx, prod, c) => ListView.builder(
                            itemCount: prod.items.length,
                            itemBuilder: (context, index) => Column(
                                  children: <Widget>[
                                    UserproductItem(
                                      prod.items[index].id,
                                      prod.items[index].title,
                                      prod.items[index].imgUrl,
                                    ),
                                    Divider(),
                                  ],
                                )),
                      ),
                    ),
                  ),
      ),
    );
  }
}
