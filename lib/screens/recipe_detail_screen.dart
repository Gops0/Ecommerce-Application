import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_chef_master/models/cart_item.dart';
import 'package:ai_chef_master/providers/cart_provider.dart';
import 'package:ai_chef_master/models/recipe.dart'; // Assuming you have a Recipe model


class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: Column(
        children: <Widget>[
          Image.network(recipe.imageUrl),
          SizedBox(height: 10),
          Text(
            recipe.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${recipe.price}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFA500), // Direct hex color code for orange
            ),
            onPressed: () {
              // Convert Recipe to CartItem
              final cartItem = CartItem(
                id: recipe.id,
                title: recipe.title,
                price: recipe.price,
                quantity: 1,  // Default quantity
                imageUrl: recipe.imageUrl,
              );

              // Add the CartItem to the cart provider
              cartProvider.addToCart(cartItem);

              // Show a confirmation message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${recipe.title} added to cart')),
              );
            },
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
