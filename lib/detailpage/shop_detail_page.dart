import 'package:flutter/material.dart';
import 'package:flutter_app/pages/shop_page.dart';
import 'package:flutter_app/detailpage/generic_detail_page.dart';
import 'package:flutter_app/models/place_model.dart';
import '../widgets/shared_widgets.dart'; // Import shared widgets

class ShopDetailPage extends StatelessWidget {
  final Shop shop;

  const ShopDetailPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final place = Place(
      id: shop.id,
      name: shop.name,
      description: shop.description,
      imagePath: shop.imageUrl,
    );

    return GenericDetailPage(
      place: place,
      funFact: shop.funFact,
      detailWidgets: [
        InfoRow(icon: Icons.category_outlined, text: 'Category: ${shop.category}'),
        InfoRow(icon: Icons.location_on_outlined, text: 'Location: ${shop.location}'),
        InfoRow(icon: Icons.star, text: 'Rating: ${shop.rating} / 5.0'),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InfoRow(icon: icon, text: '$label: $value', iconColor: Colors.grey.shade600, textColor: Colors.black87, textSize: 16),
    );
  }
}