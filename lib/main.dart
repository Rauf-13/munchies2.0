// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'providers/group_order_provider.dart';
import 'providers/wellness_provider.dart';
import 'screens/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MunchiesApp());
}

class MunchiesApp extends StatelessWidget {
  const MunchiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GroupOrderProvider()),
        ChangeNotifierProvider(create: (_) => WellnessProvider()),
      ],
      child: MaterialApp(
        title: 'Munchies',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Inter',
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
