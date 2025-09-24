// lib/pages/hotel_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'base_page.dart';
import 'package:provider/provider.dart';

// Inheritance: Hotel extends Destination
class Hotel extends Destination {
  final double _rating;
  final double price;

  // Encapsulation: Using named parameters for clarity
  Hotel({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required double rating,
    required this.price,
  })  : _rating = rating,
        super(id, name, description, imageUrl);

  double get rating => _rating;
}

// Inheritance & Polymorphism: HotelPage extends BasePage and overrides buildContent
class HotelPage extends BasePage {
  const HotelPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    final List<Hotel> hotels = [
      Hotel(
        id: 'h1',
        name: 'Tokyo Grand Hotel',
        description: 'A luxurious stay in the heart of Tokyo.',
        imageUrl: 'assets/hotel/tokyo_grand.png',
        rating: 4.8,
        price: 30000,
      ),
      Hotel(
        id: 'h2',
        name: 'Kyoto Traditional Ryokan',
        description: 'Experience authentic Japanese hospitality.',
        imageUrl: 'assets/hotel/kyoto_ryokan.png',
        rating: 4.5,
        price: 45000,
      ),
      Hotel(
        id: 'h3',
        name: 'Park Hyatt Tokyo',
        description: 'Iconic hotel from "Lost in Translation".',
        imageUrl: 'assets/hotel/park_hyatt.png',
        rating: 4.9,
        price: 80000,
      ),
      Hotel(
        id: 'h4',
        name: 'Hoshinoya Kyoto',
        description: 'A riverside luxury ryokan in Arashiyama.',
        imageUrl: 'assets/hotel/hoshinoya.png',
        rating: 4.9,
        price: 120000,
      ),
    ];

    return ListView.builder(
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        final hotel = hotels[index];
        final place = Place(
          id: hotel.id,
          name: hotel.name,
          description: hotel.description,
          imagePath: hotel.imageUrl,
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
                hotel.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hotel.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(hotel.description, style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.attach_money, '¥${hotel.price.toStringAsFixed(0)} / night'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildRatingStars(hotel.rating),
                        const SizedBox(width: 8),
                        Text(hotel.rating.toString(), style: TextStyle(color: Colors.grey.shade700)),
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