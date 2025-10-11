import 'package:flutter/material.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'splash.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
        primaryColor: const Color(0xFF0D47A1),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: const Color(0xFF1976D2),
          backgroundColor: Colors.grey.shade100,
        ),
        scaffoldBackgroundColor: Colors.grey.shade100,
        fontFamily: GoogleFonts.mPlusRounded1c(fontWeight: FontWeight.w500).fontFamily,
      ),
      home: const SplashScreen(),
    );
  }
}
