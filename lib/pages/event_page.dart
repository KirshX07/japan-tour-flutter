// lib/pages/event_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'base_page.dart';
import 'package:provider/provider.dart';

// Inheritance: Event extends Destination
class Event extends Destination {
  final String _date;
  final double price;
  final double rating;

  Event({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required String date,
    required this.price,
    required this.rating,
  })  : _date = date,
        super(id, name, description, imageUrl);

  String get date => _date;
}

// Polymorphism: EventPage extends BasePage and overrides buildContent
class EventPage extends BasePage {
  const EventPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    final List<Event> events = [
      Event(
        id: 'e4',
        name: 'Gion Matsuri',
        description: 'Famous festival of Yasaka Shrine in Kyoto.',
        imageUrl: 'assets/events/matsuri.png',
        date: 'July',
        price: 0, // Free event
        rating: 4.8,
      ),
      Event(
        id: 'e2',
        name: 'Kyoto Autumn Illumination',
        description: 'See the temples beautifully lit up.',
        imageUrl: 'assets/events/autumn_kyoto.png',
        date: 'Mid-Nov to Early-Dec',
        price: 600,
        rating: 4.9,
      ),
      Event(
        id: 'e3',
        name: 'Sapporo Snow Festival',
        description: 'A winter wonderland of ice and snow sculptures.',
        imageUrl: 'assets/events/sapporo_snow.png',
        date: 'February',
        price: 0, // Free to view
        rating: 4.7,
      ),
    ];

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final place = Place(
          id: event.id,
          name: event.name,
          description: event.description,
          imagePath: event.imageUrl,
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
                event.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(event.description, style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.calendar_today, 'Date: ${event.date}'),
                    const SizedBox(height: 6),
                    _buildInfoRow(Icons.attach_money, event.price > 0 ? 'Ticket: ¥${event.price.toStringAsFixed(0)}' : 'Free Event'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildRatingStars(event.rating),
                        const SizedBox(width: 8),
                        Text(event.rating.toString(), style: TextStyle(color: Colors.grey.shade700)),
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