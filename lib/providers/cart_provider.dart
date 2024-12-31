import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart'; // Ensure this import is correct

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  // Getter for cart items
  Map<String, CartItem> get items => {..._items};

  // Load cart data from SharedPreferences
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');
    
    if (cartData != null) {
      final List<dynamic> decodedData = json.decode(cartData);
      for (var itemData in decodedData) {
        _items[itemData['id']] = CartItem.fromMap(itemData);
      }
    }
    notifyListeners();
  }

  // Method to clear the cart
  void clearCart() {
    _items = {};
    notifyListeners();
  }

  // Save cart data to SharedPreferences
  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> cartList = [];
    _items.forEach((key, cartItem) {
      cartList.add(cartItem.toMap());
    });
    prefs.setString('cart', json.encode(cartList));
  }

  // Add item to cart
  Future<void> addToCart(CartItem item) async {
    if (_items.containsKey(item.id)) {
      _items.update(item.id, (existingItem) {
        return CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
          imageUrl: existingItem.imageUrl,
        );
      });
    } else {
      _items.putIfAbsent(item.id, () => item);
    }
    await saveCart();  // Save cart data after adding item
    notifyListeners();
  }

  // Remove item from cart (or decrease quantity if more than 1)
  Future<void> removeFromCart(String id) async {
    if (_items.containsKey(id)) {
      if (_items[id]!.quantity > 1) {
        _items.update(id, (existingItem) {
          return CartItem(
            id: existingItem.id,
            title: existingItem.title,
            price: existingItem.price,
            quantity: existingItem.quantity - 1,
            imageUrl: existingItem.imageUrl,
          );
        });
      } else {
        _items.remove(id);
      }
      await saveCart();  // Save cart data after updating
      notifyListeners();
    }
  }

  // Get total price
  double get totalPrice {
    return _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
}
