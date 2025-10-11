// lib/pages/event_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'package:flutter_app/pages/base_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../detailpage/event_detail_page.dart';
import '../widgets/shared_widgets.dart';

class Event extends Destination {
  final DateTime date;
  final String location;
  final String category;
  final String? funFact;
  final double? rating;

  Event({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required this.date,
    required this.location,
    required this.category,
    this.funFact,
    this.rating,
  }) : super(id, name, description, imageUrl);
}

class EventPage extends BasePage {
  const EventPage({super.key});

  @override
  String get pageTitle => 'Events in Japan';

  @override
  Widget buildContent(BuildContext context) {
    final events = [
      Event(
        id: 'e1',
        name: 'Gion Matsuri',
        description: 'One of Japan\'s most famous festivals, held in Kyoto.',
        imageUrl: 'assets/events/matsuri.png',
        date: DateTime(DateTime.now().year, 7, 1),
        location: 'Kyoto',
        category: 'Festival',
        funFact: 'Started in the 9th century as a religious ceremony.',
        rating: 4.8,
      ),
      Event(
        id: 'e2',
        name: 'Sapporo Snow Festival',
        description: 'A winter wonderland with massive snow and ice sculptures.',
        imageUrl: 'assets/seasons/winter.png',
        date: DateTime(DateTime.now().year + 1, 2, 4),
        location: 'Sapporo, Hokkaido',
        category: 'Seasonal',
        funFact: 'Started in 1950 by students; now attracts millions.',
        rating: 4.9,
      ),
      Event(
        id: 'e3',
        name: 'AnimeJapan',
        description: 'The largest anime convention in Japan, held in Tokyo.',
        imageUrl: 'assets/events/concert.png',
        date: DateTime(DateTime.now().year + 1, 3, 23),
        location: 'Tokyo Big Sight',
        category: 'Convention',
        funFact: 'Major anime event for new releases & merchandise.',
        rating: 4.6,
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
        context.read<PlannerProvider>().addItem(PlannerItem(place: place, date: pickedDate));
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
              IconButton(
                icon: const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 22),
                onPressed: () => showDatePickerLocal(context, place),
              ),
              IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : Colors.white70, size: 22),
                onPressed: () => favoritesProvider.toggleFavorite(place),
              ),
            ],
          );
        },
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF311B92), Color(0xFF512DA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView.builder(
        itemCount: events.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final event = events[index];
          final place = Place(
            id: event.id,
            name: event.name,
            description: event.description,
            imagePath: event.imageUrl,
            rating: event.rating,
          );

          return AnimatedListItem(
            index: index,
            child: Card(
              color: Colors.white.withOpacity(0.1),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EventDetailPage(event: event)),
                    ),
                    child: Hero(
                      tag: event.id,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
                        child: Image.asset(event.imageUrl,
                            width: 130, height: 150, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(event.description,
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(event.rating?.toStringAsFixed(1) ?? 'N/A',
                                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          InfoRow(
                              icon: Icons.calendar_today,
                              text: DateFormat.yMMMMd().format(event.date),
                              iconColor: Colors.white70,
                              textColor: Colors.white70),
                          InfoRow(
                              icon: Icons.location_on,
                              text: event.location,
                              iconColor: Colors.white70,
                              textColor: Colors.white70),
                          InfoRow(
                              icon: Icons.category_outlined,
                              text: event.category,
                              iconColor: Colors.white70,
                              textColor: Colors.white70),
                          const SizedBox(height: 4),
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
