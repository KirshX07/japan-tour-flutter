import 'package:flutter/material.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (context) => PlannerProvider()),
      ],
      child: const JapanTourApp(),
    ),
  );
}

class JapanTourApp extends StatelessWidget {
  const JapanTourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Japan Tour',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}
