import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';

import '../providers/card.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.amount,
    @required this.dateTime,
    @required this.id,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> setAndFeach() async {
    final url =
        Uri.https('shop-app-a1fbe-default-rtdb.firebaseio.com', '/orders.json');
    final responce = await http.get(url);
    // print(
    //   json.decode(responce.body),
    // );
    final extractedData = json.decode(responce.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    final List<OrderItem> _finalList = [];
    extractedData.forEach((orderId, ordervalue) {
      _finalList.add(
        OrderItem(
          amount: ordervalue['amount'],
          dateTime: DateTime.parse(ordervalue['dateTime']),
          id: orderId,
          products: (ordervalue['products'] as List<dynamic>)
              .map((orderItem) => CartItem(
                  id: orderItem['id'],
                  price: orderItem['price'],
                  quantity: orderItem['quantity'],
                  title: orderItem['title']))
              .toList(),
        ),
      );
      _orders = _finalList.reversed.toList();
      notifyListeners();
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        Uri.https('shop-app-a1fbe-default-rtdb.firebaseio.com', '/orders.json');
    try {
      final timeStamp = DateTime.now();
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'price': e.price,
                      'quantity': e.quantity,
                    })
                .toList(),
          },
        ),
      );
      _orders.insert(
        0,
        OrderItem(
          amount: total,
          dateTime: timeStamp,
          id: json.decode(response.body)['name'],
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
