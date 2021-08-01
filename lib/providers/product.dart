import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });
  Future<void> triggerFavoritestates() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final url = Uri.https(
          'shop-app-a1fbe-default-rtdb.firebaseio.com', '/products/$id.json');
      final response = await http.patch(
        url,
        body: json.encode({'isFavorite': isFavorite}),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (erreo) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
