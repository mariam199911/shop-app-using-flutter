import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../providers/card.dart';

enum FilterOption { favorite, all }

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _isFavorite = false; // لازم اعرف الفاريابل هنا مينعفش اعرفه جوا ال widget
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).setData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.favorite) {
                  _isFavorite = true;
                  //productsContainer.showFavorites();
                } else {
                  _isFavorite = false;
                  // productsContainer.showAll();
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Only Favorites"),
                value: FilterOption.favorite,
              ),
              PopupMenuItem(
                child: Text("All Products"),
                value: FilterOption.all,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CartScreen.routeName,
                  );
                }),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_isFavorite),
    );
  }
}
