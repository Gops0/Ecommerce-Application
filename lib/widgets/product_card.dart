import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../database/cart_database.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  void addToCart(BuildContext context) async {
    final item = {
      'name': product.name,
      'price': product.price,
      'image': product.image,
      'quantity': 1,
    };
    await CartDatabase.instance.addItem(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 50, color: Colors.grey);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(product.description, style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text('₹ ${product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 14, color: Colors.green)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => addToCart(context),
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
