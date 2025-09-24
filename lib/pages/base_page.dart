// lib/pages/base_page.dart
import 'package:flutter/material.dart';

// Encapsulation: The base class for all data models
abstract class Destination {
  final String id;
  final String _name;
  final String _description;
  final String _imageUrl;

  Destination(this.id, this._name, this._description, this._imageUrl);

  String get name => _name;
  String get description => _description;
  String get imageUrl => _imageUrl;
}

// Polymorphism: A base class for all the content pages
abstract class BasePage extends StatefulWidget {
  const BasePage({super.key});

  // This method will be overridden by subclasses to define their unique UI
  Widget buildContent(BuildContext context);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  bool _animateBanner = false;

  @override
  void initState() {
    super.initState();
    // jalankan animasi setelah build
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _animateBanner = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
            height: _animateBanner ? 110 : 0,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(top: 40),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(left: 4, child: BackButton(color: Colors.white)),
                Text(
                  widget.runtimeType.toString().replaceAll('Page', ''),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: widget.buildContent(context),
            ),
          ),
        ],
      ),
    );
  }
}