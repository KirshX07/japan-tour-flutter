// lib/pages/experience_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'base_page.dart';
import 'package:provider/provider.dart';

class Experience extends Destination {
  final String _type;
  final double price;
  final double rating;

  Experience({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required String type,
    required this.price,
    required this.rating,
  })  : _type = type,
        super(id, name, description, imageUrl);
  String get type => _type;
}

class ExperiencePage extends BasePage {
  const ExperiencePage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    final experiences = [
      Experience(id: 'ex1', name: 'Ghibli Museum', description: 'Dive into the world of Studio Ghibli.', imageUrl: 'assets/experience/ghibli.png', type: 'Museum', price: 1000, rating: 4.6),
      Experience(id: 'ex2', name: 'Hakone Onsen', description: 'Relax in natural hot springs with a view.', imageUrl: 'assets/popular/hakone.png', type: 'Relaxation', price: 1500, rating: 4.8),
      Experience(id: 'ex3', name: 'Tea Ceremony', description: 'Participate in a traditional Japanese tea ceremony.', imageUrl: 'assets/experience/tea_ceremony.png', type: 'Culture', price: 3000, rating: 4.7),
      Experience(id: 'ex4', name: 'Samurai Experience', description: 'Learn the way of the warrior in Kyoto.', imageUrl: 'assets/experience/samurai.png', type: 'Activity', price: 11000, rating: 4.9),
      Experience(id: 'ex5', name: 'Sumo Stable Visit', description: 'Watch a morning training session of sumo wrestlers.', imageUrl: 'assets/experience/sumo.png', type: 'Culture', price: 10000, rating: 4.5),
    ];
    return ListView.builder(
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final experience = experiences[index];
        final place = Place(
          id: experience.id,
          name: experience.name,
          description: experience.description,
          imagePath: experience.imageUrl,
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
                experience.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(experience.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(experience.description, style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.category_outlined, 'Type: ${experience.type}'),
                    const SizedBox(height: 6),
                    _buildInfoRow(Icons.attach_money, 'Price: ¥${experience.price.toStringAsFixed(0)}'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildRatingStars(experience.rating),
                        const SizedBox(width: 8),
                        Text(experience.rating.toString(), style: TextStyle(color: Colors.grey.shade700)),
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