import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ProductService {
  static Future<List<Recipe>> fetchProducts() async {
    const String apiUrl = "https://fakestoreapi.com/products";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) {
          return Recipe(
            id: item['id'].toString(),
            title: item['title'],
            description: item['description'],
            imageUrl: item['image'],
            price: item['price'].toDouble(),
          );
        }).toList();
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }
}
