import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'base_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../detailpage/hotel_detail_page.dart';
import '../widgets/shared_widgets.dart';

class Hotel extends Destination {
  final double _rating;
  final double price;
  final String? funFact;
  final String? bestTimeToVisit;
  final String? peakSeason;
  final String? longDescription;

  Hotel({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required double rating,
    required this.price,
    this.funFact,
    this.bestTimeToVisit,
    this.peakSeason,
    this.longDescription,
  })  : _rating = rating,
        super(id, name, description, imageUrl);

  double get rating => _rating;
}

class HotelPage extends BasePage {
  const HotelPage({super.key});

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
            backgroundColor: Colors.green.shade600,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              _iconAction(
                icon: Icons.calendar_today_outlined,
                color: Colors.blueAccent,
                tooltip: 'Add to planner',
                onTap: () => showDatePickerLocal(context, place),
              ),
              const SizedBox(width: 8),
              _iconAction(
                icon: isFavorited ? Icons.favorite : Icons.favorite_border,
                color: isFavorited ? Colors.redAccent : Colors.white70,
                tooltip: 'Add to favorites',
                onTap: () => favoritesProvider.toggleFavorite(place),
              ),
            ],
          );
        },
      );
    }

    final List<Hotel> hotels = [
      Hotel(
        id: 'h1',
        name: 'Tokyo Grand Hotel',
        description: 'A luxurious stay in the heart of Tokyo.',
        imageUrl: 'assets/hotel/tokyo_grand.png',
        rating: 4.8,
        price: 30000,
        funFact: 'Some hotels in Japan offer capsule rooms!',
        bestTimeToVisit: 'Check-in after 3 PM for a smoother experience.',
        peakSeason: 'Golden Week (late April to early May)',
        longDescription:
            'Located near Tokyo Station, offering world-class amenities and breathtaking city views. Ideal for both business and leisure travelers.',
      ),
      Hotel(
        id: 'h2',
        name: 'Kyoto Traditional Ryokan',
        description: 'Experience authentic Japanese hospitality.',
        imageUrl: 'assets/hotel/kyoto_ryokan.png',
        rating: 4.5,
        price: 45000,
        funFact: 'Sleep on futons, wear yukata, and enjoy kaiseki dinners.',
        peakSeason: 'Autumn for the best foliage views.',
        longDescription:
            'Tranquil ryokan with serene garden views and a relaxing onsen experience after exploring Kyoto’s historic temples.',
      ),
      Hotel(
        id: 'h3',
        name: 'Park Hyatt Tokyo',
        description: 'Iconic hotel from "Lost in Translation".',
        imageUrl: 'assets/hotel/park_hyatt.png',
        rating: 4.9,
        price: 80000,
        funFact: 'The New York Bar offers 360° skyline views of Tokyo.',
      ),
      Hotel(
        id: 'h4',
        name: 'Hoshinoya Kyoto',
        description: 'A riverside luxury ryokan in Arashiyama.',
        imageUrl: 'assets/hotel/hoshinoya.png',
        rating: 4.9,
        price: 120000,
        funFact: 'Guests arrive via a private boat along the Ōi River.',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        final hotel = hotels[index];
        final place = Place(
          id: hotel.id,
          name: hotel.name,
          description: hotel.description,
          imagePath: hotel.imageUrl,
          bestTimeToVisit: hotel.bestTimeToVisit,
          peakSeason: hotel.peakSeason,
          longDescription: hotel.longDescription,
        );

        return AnimatedListItem(
          index: index,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HotelDetailPage(hotel: hotel)),
                );
              },
              child: Row(
                children: [
                  // 🖼️ Gambar Hotel
                  Hero(
                    tag: hotel.id,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      child: Image.asset(
                        hotel.imageUrl,
                        width: 130,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // 📄 Info Hotel
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotel.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            hotel.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              RatingStars(rating: hotel.rating, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                hotel.rating.toString(),
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          InfoRow(
                            icon: Icons.attach_money,
                            text:
                                'From ¥${NumberFormat.compact().format(hotel.price)}/night',
                            iconColor: Colors.greenAccent,
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
          ),
        );
      },
    );
  }

  Widget _iconAction({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}
