import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart'; // Make sure this is imported

class CheckoutScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalPrice;

  // Constructor to receive cart data
  CheckoutScreen({required this.cartItems, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Displaying the bill details
            Text(
              'Bill Summary',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (ctx, i) {
                  final item = cartItems[i];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(item.imageUrl, width: 50, fit: BoxFit.cover),
                      ),
                      title: Text(item.title),
                      subtitle: Text('₹${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                    ),
                  );
                },
              ),
            ),
            // Displaying the total amount
            Text(
              'Total: ₹${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Button to complete the purchase
            ElevatedButton(
              onPressed: () {
                // Clear the cart
                cartProvider.clearCart();
                // Show a success message
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Purchase Successful'),
                    content: Text('Thank you for your purchase!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context); // Navigate back to home screen
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Complete Purchase'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
