// lib/pages/base_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/page_header.dart';

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
abstract class BasePage extends StatelessWidget {
  const BasePage({super.key});

  /// Subclasses must override this to provide a title for the header.
  String get pageTitle;

  // This method will be overridden by subclasses to define their unique UI
  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF4A148C)], // Background gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PageHeader(title: pageTitle),
        body: SafeArea(
          child: buildContent(context),
        ),
      ),
    );
  }
}