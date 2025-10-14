import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'package:provider/provider.dart';
import 'base_page.dart';
import '../detailpage/transport_detail_page.dart';
import '../widgets/shared_widgets.dart';

class Transport extends Destination {
  final double _cost;
  final double rating;
  final String? funFact;
  final String? bestTimeToVisit;
  final String? peakSeason;

  Transport({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required double cost,
    required this.rating,
    this.funFact,
    this.bestTimeToVisit,
    this.peakSeason,
  })  : _cost = cost,
        super(id, name, description, imageUrl);

  double get cost => _cost;
}

class TransportPage extends BasePage {
  const TransportPage({super.key});

  @override
  String get pageTitle => 'Transport';

  @override
  Widget buildContent(BuildContext context) {
    Future<void> showDatePickerLocal(BuildContext context, Place place) async {
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

    Widget buildActionBarLocal(BuildContext context, Place place) {
      return Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final isFavorited = favoritesProvider.isFavorite(place);
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.calendar_today_outlined, size: 22),
                color: Theme.of(context).colorScheme.secondary,
                tooltip: 'Add to planner',
                onPressed: () => showDatePickerLocal(context, place),
              ),
              IconButton(
                icon: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    size: 22),
                color: isFavorited ? Colors.redAccent : Colors.grey,
                tooltip: 'Add to favorites',
                onPressed: () => favoritesProvider.toggleFavorite(place),
              ),
            ],
          );
        },
      );
    }

    final transports = [
      Transport(
        id: 't1',
        name: 'Shinkansen',
        description: 'Japan\'s high-speed bullet train network.',
        imageUrl: 'assets/transport/shinkansen.png',
        cost: 15000.0,
        rating: 4.9,
        funFact:
            'The Shinkansen is known for its punctuality; the average delay is less than a minute.',
        bestTimeToVisit:
            'Avoid rush hours on holidays for more comfortable seating.',
      ),
      Transport(
        id: 't2',
        name: 'Tokyo Metro',
        description: 'Efficient subway for city travel.',
        imageUrl: 'assets/transport/metro.png',
        cost: 200.0,
        rating: 4.5,
        funFact:
            'Some Tokyo stations are so large they are like underground cities with shops and restaurants.',
      ),
      Transport(
        id: 't3',
        name: 'Japan Rail Pass',
        description: 'Cost-effective pass for long-distance train travel.',
        imageUrl: 'assets/transport/jrpass.png',
        cost: 50000.0,
        rating: 4.8,
        funFact:
            'The JR Pass is only available for foreign tourists and must be purchased outside of Japan.',
        peakSeason: 'Activate your pass carefully; it runs on consecutive days.',
      ),
      Transport(
        id: 't4',
        name: 'Suica / Pasmo Card',
        description: 'Rechargeable smart card for public transport.',
        imageUrl: 'assets/transport/suica.png',
        cost: 2000.0,
        rating: 4.7,
        funFact:
            'Besides transport, these cards can be used at many vending machines and stores.',
      ),
      Transport(
        id: 't5',
        name: 'Highway Bus',
        description: 'Affordable intercity travel option.',
        imageUrl: 'assets/transport/bus.png',
        cost: 4000.0,
        rating: 3.9,
        funFact:
            'Overnight buses help travelers save on both transport and accommodation.',
      ),
      Transport(
        id: 't6',
        name: 'All Nippon Airways (ANA)',
        description: 'Major airline for domestic and international flights.',
        imageUrl: 'assets/transport/ana.png', // Placeholder image
        cost: 20000.0,
        rating: 4.8,
        funFact:
            'ANA is a member of the Star Alliance and is known for its excellent service.',
        bestTimeToVisit:
            'Popular routes: Tokyo (Haneda) → Sapporo, Fukuoka, Okinawa.',
      ),
      Transport(
        id: 't7',
        name: 'Japan Airlines (JAL)',
        description: 'Japan\'s flag carrier, offering extensive domestic routes.',
        imageUrl: 'assets/transport/jal.png', // Placeholder image
        cost: 19000.0,
        rating: 4.7,
        funFact:
            'JAL is part of the Oneworld alliance and was once a government-owned airline.',
        bestTimeToVisit:
            'Popular routes: Tokyo → Osaka, Hiroshima, Kagoshima.',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: transports.length,
      itemBuilder: (context, index) {
        final transport = transports[index];
        final place = Place(
          id: transport.id,
          name: transport.name,
          description: transport.description,
          imagePath: transport.imageUrl,
          bestTimeToVisit: transport.bestTimeToVisit,
          peakSeason: transport.peakSeason,
        );

        return AnimatedListItem(
          index: index,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4A148C).withOpacity(0.25),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TransportDetailPage(transport: transport)),
                    );
                  },
                  child: Hero(
                    tag: transport.id,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      child: Image.asset(
                        transport.imageUrl,
                        width: 130,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transport.name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transport.description,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            RatingStars(rating: transport.rating, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              transport.rating.toString(),
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        InfoRow(
                          icon: Icons.attach_money,
                          text:
                              'Cost: ¥${transport.cost.toStringAsFixed(0)}',
                          iconColor: Colors.white70,
                          textColor: Colors.white70,
                        ),
                        const SizedBox(height: 6),
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
    );
  }
}
