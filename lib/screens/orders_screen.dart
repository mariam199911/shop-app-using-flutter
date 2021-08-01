import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/orderItem.dart' as or;
import '../widgets/app_drawer.dart';

// class OrdersScreen extends StatefulWidget {
//   static const routeName = '/orders';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   var _isLoading = false;
//   @override
//   void initState() {
//     //Future.delayed(Duration.zero).then((_) async {
//     // setState(() {
//     _isLoading = true;
//     // });
//     Provider.of<Orders>(context, listen: false).setAndFeach().then((_) {
//       setState(() {
//         _isLoading = false;
//       });
//     });

//     //});
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final orderData = Provider.of<Orders>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Your Orders"),
//       ),
//       drawer: AppDrawer(),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : ListView.builder(
//               itemCount: orderData.orders.length,
//               itemBuilder: (ctx, i) => or.OrderItem(orderData.orders[i])),
//     );
//   }
// }
//####################another solution#####################################
// class OrdersScreen extends StatelessWidget {
//   static const routeName = '/orders';

//   @override
//   Widget build(BuildContext context) {
//     print('building orders');
//     // final orderData = Provider.of<Orders>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your Orders'),
//       ),
//       drawer: AppDrawer(),
//       body: FutureBuilder(
//         future: Provider.of<Orders>(context, listen: false).setAndFeach(),
//         builder: (ctx, dataSnapshot) {
//           if (dataSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else {
//             if (dataSnapshot.error != null) {
//               // ...
//               // Do error handling stuff
//               return Center(
//                 child: Text('An error occurred!'),
//               );
//             } else {
//               return Consumer<Orders>(
//                 builder: (ctx, orderData, child) => ListView.builder(
//                   itemCount: orderData.orders.length,
//                   itemBuilder: (ctx, i) => or.OrderItem(orderData.orders[i]),
//                 ),
//               );
//             }
//           }
//         },
//       ),
//     );
//   }
// }
//####################another solution#####################################
// عملنا كدا عشان نتجنب اننا نعمل ريكويست ف كل مره حاجه تتغير ف الصفحه
class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _orderFuture;
  Future _obtainOrderFuture() {
    return Provider.of<Orders>(context, listen: false).setAndFeach();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building orders');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => or.OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
