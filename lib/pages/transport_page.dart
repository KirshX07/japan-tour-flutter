// lib/pages/transport_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'package:provider/provider.dart';
import 'base_page.dart';

class Transport extends Destination {
    final double _cost;
    final double rating;
  Transport({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required double cost,
    required this.rating,
  })  : _cost = cost,
        super(id, name, description, imageUrl);
  double get cost => _cost;
}

class TransportPage extends BasePage {
  const TransportPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    final transports = [
      Transport(id: 't1', name: 'Shinkansen', description: 'Japan\'s high-speed bullet train network.', imageUrl: 'assets/transport/shinkansen.png', cost: 15000.0, rating: 4.9),
      Transport(id: 't2', name: 'Tokyo Metro', description: 'Efficient subway for city travel.', imageUrl: 'assets/transport/metro.png', cost: 200.0, rating: 4.5),
      Transport(id: 't3', name: 'Japan Rail Pass', description: 'Cost-effective pass for long-distance train travel.', imageUrl: 'assets/transport/jrpass.png', cost: 50000.0, rating: 4.8),
      Transport(id: 't4', name: 'Suica / Pasmo Card', description: 'Rechargeable smart card for public transport.', imageUrl: 'assets/transport/suica.png', cost: 2000.0, rating: 4.7),
      Transport(id: 't5', name: 'Highway Bus', description: 'An affordable option for intercity travel.', imageUrl: 'assets/transport/bus.png', cost: 4000.0, rating: 3.9),
    ];
    return ListView.builder(
    itemCount: transports.length,
      itemBuilder: (context, index) {
        final transport = transports[index];
        // Konversi Transport menjadi objek Place agar bisa digunakan oleh FavoritesProvider
        final place = Place(
          id: transport.id,
          name: transport.name,
          description: transport.description,
          imagePath: transport.imageUrl,
        );

        // Gunakan Consumer untuk mendapatkan status favorit dan membangun ulang UI saat berubah
        return Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, child) {
            final isFavorited = favoritesProvider.isFavorite(place);
            return Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    transport.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(transport.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(transport.description, style: TextStyle(color: Colors.grey.shade600)),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.attach_money, 'Cost: ¥${transport.cost.toStringAsFixed(0)}'),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _buildRatingStars(transport.rating),
                            const SizedBox(width: 8),
                            Text(transport.rating.toString(), style: TextStyle(color: Colors.grey.shade700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(icon: const Icon(Icons.calendar_today_outlined, color: Colors.blueGrey), tooltip: 'Add to planner', onPressed: () => _showDatePicker(context, place)),
                        IconButton(icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border, color: isFavorited ? Colors.red : Colors.grey), tooltip: 'Add to favorites', onPressed: () => favoritesProvider.toggleFavorite(place)),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
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