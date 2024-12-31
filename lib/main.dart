import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './providers/cart_provider.dart';
import './screens/home_screen.dart';
import './screens/cart_screen.dart';
import './screens/login_screen.dart';
import './screens/splash_screen.dart';
import './screens/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CartProvider()..loadCart(), // Load cart on startup
      child: MaterialApp(
        title: 'AI Chef Master',
        theme: ThemeData(primarySwatch: Colors.orange),
        initialRoute: '/',
        routes: {
          '/': (ctx) => SplashScreen(),
          '/home': (ctx) => HomeScreen(),
          '/cart': (ctx) => CartScreen(),
          '/login': (ctx) => LoginScreen(),
          '/register': (ctx) => RegisterScreen(),

        },
      ),
    );
  }
}
