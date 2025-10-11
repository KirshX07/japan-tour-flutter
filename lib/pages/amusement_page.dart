// lib/pages/amusement_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../detailpage/amusement_detail_page.dart';
import '../widgets/shared_widgets.dart';
import 'base_page.dart';

class Amusement extends Destination {
  final double price;
  final double rating;
  final String? funFact;

  Amusement({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required this.price,
    required this.rating,
    this.funFact,
  }) : super(id, name, description, imageUrl);
}

class AmusementPage extends BasePage {
  const AmusementPage({super.key});

  @override
  String get pageTitle => 'Amusement';

  @override
  Widget buildContent(BuildContext context) {
    final amusements = [
      Amusement(
        id: 'a1',
        name: 'Tokyo Disneyland',
        description: 'The kingdom of dreams and magic.',
        imageUrl: 'assets/amusement/disney.png',
        price: 8400,
        rating: 4.8,
        funFact: 'It was the first Disney park built outside the U.S.',
      ),
      Amusement(
        id: 'a2',
        name: 'Universal Studios Japan',
        description: 'Ride the movies in Osaka.',
        imageUrl: 'assets/amusement/universal.png',
        price: 8600,
        rating: 4.7,
        funFact:
            'The Wizarding World of Harry Potter has a real-scale Hogwarts castle.',
      ),
      Amusement(
        id: 'a3',
        name: 'Fuji-Q Highland',
        description: 'For thrill-seekers with record-breaking roller coasters.',
        imageUrl: 'assets/amusement/fujiq.png',
        price: 6200,
        rating: 4.4,
        funFact: 'It holds multiple Guinness World Records for intense rides.',
      ),
      Amusement(
        id: 'a4',
        name: 'Ghibli Park',
        description: 'Step into the world of Studio Ghibli.',
        imageUrl: 'assets/amusement/ghibli_park.png',
        price: 2500,
        rating: 4.6,
        funFact:
            'You are encouraged to "get lost" and explore freely — no fixed paths.',
      ),
      Amusement(
        id: 'a5',
        name: 'Sanrio Puroland',
        description: 'Meet Hello Kitty and her friends.',
        imageUrl: 'assets/amusement/sanrio.png',
        price: 3600,
        rating: 4.2,
        funFact:
            'An indoor theme park dedicated to Sanrio characters like Gudetama.',
      ),
    ];

    Future<void> showDatePickerLocal(BuildContext context, Place place) async {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );

      if (pickedDate != null && context.mounted) {
        context.read<PlannerProvider>().addItem(
              PlannerItem(place: place, date: pickedDate),
            );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${place.name} added to planner!')),
        );
      }
    }

    Widget buildActionBarLocal(BuildContext context, Place place) {
      return Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final isFav = favoritesProvider.isFavorite(place);
          return Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined,
                      color: Colors.white, size: 20),
                  onPressed: () => showDatePickerLocal(context, place),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : Colors.white,
                    size: 22,
                  ),
                  onPressed: () => favoritesProvider.toggleFavorite(place),
                ),
              ),
            ],
          );
        },
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF512DA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: amusements.length,
        itemBuilder: (context, index) {
          final amusement = amusements[index];
          final place = Place(
            id: amusement.id,
            name: amusement.name,
            description: amusement.description,
            imagePath: amusement.imageUrl,
          );

          return AnimatedListItem(
            index: index,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AmusementDetailPage(amusement: amusement),
                      ),
                    ),
                    child: Hero(
                      tag: amusement.id,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(20),
                        ),
                        child: Image.asset(
                          amusement.imageUrl,
                          width: 130,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            amusement.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            amusement.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                amusement.rating.toString(),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          InfoRow(
                            icon: Icons.attach_money,
                            text:
                                'Entry Fee: ${NumberFormat.currency(locale: 'ja_JP', symbol: '¥', decimalDigits: 0).format(amusement.price)}',
                            iconColor: Colors.white70,
                            textColor: Colors.white70,
                          ),
                          const SizedBox(height: 8),
                          buildActionBarLocal(context, place),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
