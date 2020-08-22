import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/widgets/drawer.dart';
import '../provider/orders.dart';
import '../utilit.dart';
import '../widgets/order_item.dart' as ord;

class OrdersScreen extends StatelessWidget {
  static final id = 'orderscreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your orders'.toUpperCase()),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).getandsetorders(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return loading();
              break;
            case ConnectionState.active:
              return loading();
              break;
            case ConnectionState.done:
              if (snapshot.hasError) {
                return nodata();
              } else {
                return Consumer<Orders>(
                    builder: (ctx, data, c) => ListView.builder(
                          itemCount: data.orders.length,
                          itemBuilder: (context, index) => ord.OrderItem(
                            orderItem: data.orders[index],
                          ),
                        ));
              }
              break;
            case ConnectionState.none:
              return connectionerror();
              break;
          }
          //  return asyncSnapshot.data;
        },
      ),
    );
  }
}
