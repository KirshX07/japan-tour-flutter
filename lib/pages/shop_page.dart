// lib/pages/shop_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'base_page.dart';
import 'package:provider/provider.dart';

class Shop extends Destination {
  final String _location;
  final String category;
  final double rating;

  Shop({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required String location,
    required this.category,
    required this.rating,
  })  : _location = location,
        super(id, name, description, imageUrl);
  String get location => _location;
}

class ShopPage extends BasePage {
  const ShopPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    final shops = [
      Shop(id: 's1', name: 'Ginza', description: 'Luxury brands and department stores.', imageUrl: 'assets/shop/ginza.png', location: 'Tokyo', category: 'Luxury', rating: 4.8),
      Shop(id: 's2', name: 'Akihabara', description: 'Center for anime and electronics.', imageUrl: 'assets/shop/akihabara.png', location: 'Tokyo', category: 'Electronics', rating: 4.6),
      Shop(id: 's3', name: 'Shinsaibashi-suji', description: 'Prime shopping arcade in Osaka.', imageUrl: 'assets/shop/shinsaibashi.png', location: 'Osaka', category: 'Arcade', rating: 4.5),
      Shop(id: 's4', name: 'Nakamise-dori', description: 'Traditional souvenirs near Senso-ji Temple.', imageUrl: 'assets/shop/nakamise.png', location: 'Tokyo', category: 'Souvenirs', rating: 4.4),
      Shop(id: 's5', name: 'Omotesando', description: 'Trendy boutiques and architecture.', imageUrl: 'assets/shop/omotesando.png', location: 'Tokyo', category: 'Boutique', rating: 4.7),
    ];
    return ListView.builder(
      itemCount: shops.length,
      itemBuilder: (context, index) {
        final shop = shops[index];
        final place = Place(
          id: shop.id,
          name: shop.name,
          description: shop.description,
          imagePath: shop.imageUrl,
        );

        return Card(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                shop.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(shop.description, style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.location_on_outlined, shop.location),
                    const SizedBox(height: 6),
                    _buildInfoRow(Icons.category_outlined, 'Category: ${shop.category}'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildRatingStars(shop.rating),
                        const SizedBox(width: 8),
                        Text(shop.rating.toString(), style: TextStyle(color: Colors.grey.shade700)),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Consumer<FavoritesProvider>(
                  builder: (context, favoritesProvider, child) {
                    final isFavorited = favoritesProvider.isFavorite(place);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(icon: const Icon(Icons.calendar_today_outlined, color: Colors.blueGrey), tooltip: 'Add to planner', onPressed: () => _showDatePicker(context, place)),
                        IconButton(icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border, color: isFavorited ? Colors.red : Colors.grey), tooltip: 'Add to favorites', onPressed: () => favoritesProvider.toggleFavorite(place)),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDatePicker(BuildContext context, Place place) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && context.mounted) {
      final plannerProvider = context.read<PlannerProvider>();
      final newItem = PlannerItem(place: place, date: pickedDate);
      plannerProvider.addItem(newItem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${place.name} added to your planner!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey.shade800)),
      ],
    );
  }

  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 20));
    }
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 20));
    }
    for (int i = (fullStars + (hasHalfStar ? 1 : 0)); i < 5; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 20));
    }
    return Row(children: stars);
  }
}