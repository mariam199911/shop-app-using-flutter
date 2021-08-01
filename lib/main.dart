import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/card.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

// to use the provider   ----->   ChangeNotifierProvider (widget)
// it will listen to any change in  Products() ----> create: (ctx) => Products(),
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, []),
          update: (ctx, auth, previosProduct) => Products(auth.token,
              previosProduct.items == null ? [] : previosProduct.items),
        ),
        // or i can use proxyProvider like this
        // ProxyProvider<Auth, Products>(update: (ctx, auth, previosProduct) => Products(auth.token,
        //       previosProduct.items == null ? [] : previosProduct.items),),

        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          //home: auth.isAuth ? AuthScreen() : ProductsOverViewScreen(),
          home: auth.isAuth ? ProductsOverViewScreen() : AuthScreen(),
          //ProductsOverViewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            //AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
