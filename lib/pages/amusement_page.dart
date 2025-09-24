// lib/pages/amusement_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'base_page.dart';
import 'package:provider/provider.dart';

class Amusement extends Destination {
  final double price; // Entry fee
  final double rating;

  Amusement({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required this.price,
    required this.rating,
  }) : super(id, name, description, imageUrl);
}

class AmusementPage extends BasePage {
  const AmusementPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    final amusements = [
      Amusement(id: 'a1', name: 'Tokyo Disneyland', description: 'The kingdom of dreams and magic.', imageUrl: 'assets/amusement/disney.png', price: 8400, rating: 4.8),
      Amusement(id: 'a2', name: 'Universal Studios Japan', description: 'Ride the movies in Osaka.', imageUrl: 'assets/amusement/universal.png', price: 8600, rating: 4.7),
      Amusement(id: 'a3', name: 'Fuji-Q Highland', description: 'For thrill-seekers, with record-breaking roller coasters.', imageUrl: 'assets/amusement/fujiq.png', price: 6200, rating: 4.4),
      Amusement(id: 'a4', name: 'Ghibli Park', description: 'Step into the world of Studio Ghibli.', imageUrl: 'assets/amusement/ghibli_park.png', price: 2500, rating: 4.6),
      Amusement(id: 'a5', name: 'Sanrio Puroland', description: 'Meet Hello Kitty and her friends.', imageUrl: 'assets/amusement/sanrio.png', price: 3600, rating: 4.2),
    ];
    return ListView.builder(
      itemCount: amusements.length,
      itemBuilder: (context, index) {
        final amusement = amusements[index];
        final place = Place(
          id: amusement.id,
          name: amusement.name,
          description: amusement.description,
          imagePath: amusement.imageUrl,
        );

        return _buildAnimatedItem(
          index: index,
          child: Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  amusement.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(amusement.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(amusement.description, style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.attach_money, 'Entry Fee: ¥${amusement.price.toStringAsFixed(0)}'),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildRatingStars(amusement.rating),
                          const SizedBox(width: 8),
                          Text(amusement.rating.toString(), style: TextStyle(color: Colors.grey.shade700)),
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

  Widget _buildAnimatedItem({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}