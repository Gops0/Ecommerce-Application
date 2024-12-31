import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/product_service.dart';
import './recipe_detail_screen.dart';
import '../models/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Recipe>> _productsFuture;
  List<Recipe> _products = [];
  User? _user;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.fetchProducts();
    _fetchProducts();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _fetchProducts() async {
    final products = await _productsFuture;
    setState(() {
      _products = products; // Initialize products
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut(); // Firebase logout
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data (e.g., tokens, user info).
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Chef Master', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_user != null) ...[
            Text('Logged in as: ${_user!.email}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
          ],
          Expanded(
            child: FutureBuilder<List<Recipe>>(
              future: _productsFuture,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error loading products: ${snapshot.error}'),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _fetchProducts(); // Retry fetching products
                            });
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Use the fetched products for display
                final displayProducts = _products;

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: displayProducts.length,
                  itemBuilder: (ctx, i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(recipe: displayProducts[i]),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                displayProducts[i].imageUrl,
                                fit: BoxFit.cover,
                                height: 150,
                                width: double.infinity,
                                errorBuilder: (ctx, error, stackTrace) => Icon(
                                  Icons.broken_image,
                                  size: 50,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black54,
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Text(
                                displayProducts[i].title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
