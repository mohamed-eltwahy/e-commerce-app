import 'package:flutter/material.dart';
import 'package:shopping/provider/products_provider.dart';
import 'package:shopping/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  bool showfav;
  ProductGrid(this.showfav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProviderProducts>(context);
    final data = (showfav) ? productsData.favourites : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(6),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
       value: data[index],
        child: ProductItem(),
      ),
      itemCount: data.length,
    );
  }
}
