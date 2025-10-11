// lib/pages/experience_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'base_page.dart';
import 'package:provider/provider.dart';
import '../detailpage/experience_detail_page.dart';
import '../widgets/shared_widgets.dart';

class Experience extends Destination {
  final String _type;
  final double price;
  final double rating;
  final String? funFact;

  Experience({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required String type,
    required this.price,
    required this.rating,
    this.funFact,
  })  : _type = type,
        super(id, name, description, imageUrl);
  String get type => _type;
}

class ExperiencePage extends BasePage {
  const ExperiencePage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    final experiences = [
      Experience(
          id: 'ex1',
          name: 'Ghibli Museum',
          description: 'Dive into the world of Studio Ghibli.',
          imageUrl: 'assets/experience/ghibli.png',
          type: 'Museum',
          price: 1000,
          rating: 4.6,
          funFact:
              'Tickets for the Ghibli Museum must be purchased in advance.'),
      Experience(
          id: 'ex2',
          name: 'Hakone Onsen',
          description: 'Relax in natural hot springs with a view.',
          imageUrl: 'assets/popular/hakone.png',
          type: 'Relaxation',
          price: 1500,
          rating: 4.8,
          funFact:
              'The black eggs (Kuro-tamago) boiled in Hakone’s springs are said to add seven years to your life.'),
      Experience(
          id: 'ex3',
          name: 'Tea Ceremony',
          description: 'Participate in a traditional Japanese tea ceremony.',
          imageUrl: 'assets/experience/tea_ceremony.png',
          type: 'Culture',
          price: 3000,
          rating: 4.7,
          funFact:
              'Every movement in a tea ceremony has symbolic meaning and precision.'),
      Experience(
          id: 'ex4',
          name: 'Samurai Experience',
          description: 'Learn the way of the warrior in Kyoto.',
          imageUrl: 'assets/experience/samurai.png',
          type: 'Activity',
          price: 11000,
          rating: 4.9,
          funFact:
              'You can learn to use a real katana (samurai sword) to slice through tatami mats.'),
      Experience(
          id: 'ex5',
          name: 'Sumo Stable Visit',
          description: 'Watch a morning training session of sumo wrestlers.',
          imageUrl: 'assets/experience/sumo.png',
          type: 'Culture',
          price: 10000,
          rating: 4.5,
          funFact:
              'Sumo wrestlers eat a massive hot pot dish called "chanko nabe" to gain weight.'),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final exp = experiences[index];
        final place = Place(
          id: exp.id,
          name: exp.name,
          description: exp.description,
          imagePath: exp.imageUrl,
        );

        return AnimatedListItem(
          index: index,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ExperienceDetailPage(experience: exp)),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Hero(
                      tag: exp.id,
                      child: Image.asset(
                        exp.imageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exp.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        exp.description,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            fontFamily: 'Poppins'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          RatingStars(rating: exp.rating, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            exp.rating.toString(),
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      InfoRow(
                          icon: Icons.category_outlined,
                          text: 'Type: ${exp.type}'),
                      const SizedBox(height: 3),
                      InfoRow(
                          icon: Icons.attach_money,
                          text: 'Price: ¥${exp.price.toStringAsFixed(0)}'),
                      const SizedBox(height: 4),
                      _buildActionBar(context, place),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionBar(BuildContext context, Place place) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFavorited = favoritesProvider.isFavorite(place);
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.calendar_today_outlined,
                  color: Colors.lightBlueAccent, size: 22),
              tooltip: 'Add to planner',
              onPressed: () => _showDatePicker(context, place),
            ),
            IconButton(
              icon: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                color: isFavorited ? Colors.redAccent : Colors.white70,
                size: 22,
              ),
              tooltip: 'Add to favorites',
              onPressed: () => favoritesProvider.toggleFavorite(place),
            ),
          ],
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
}
