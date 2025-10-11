// lib/pages/shop_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'base_page.dart';
import 'package:provider/provider.dart';
import '../detailpage/shop_detail_page.dart';
import '../widgets/shared_widgets.dart'; // Import shared widgets

class Shop extends Destination {
  final String _location;
  final String category;
  final double rating;
  final String? funFact;

  Shop({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required String location,
    required this.category,
    required this.rating,
    this.funFact,
  })  : _location = location,
        super(id, name, description, imageUrl);
  String get location => _location;
}

class ShopPage extends BasePage {
  const ShopPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    // Fungsi tambah planner
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

    // Tombol Favorite & Planner
    Widget buildActionBarLocal(BuildContext context, Place place) {
      return Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final isFavorited = favoritesProvider.isFavorite(place);
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.white70),
                tooltip: 'Add to planner',
                onPressed: () => showDatePickerLocal(context, place),
              ),
              IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.redAccent : Colors.white70,
                  size: 20,
                ),
                tooltip: 'Add to favorites',
                onPressed: () => favoritesProvider.toggleFavorite(place),
              ),
            ],
          );
        },
      );
    }

    // Data list toko
    final shops = [
      Shop(id: 's1', name: 'Ginza', description: 'Luxury brands and department stores.', imageUrl: 'assets/shop/ginza.png', location: 'Tokyo', category: 'Luxury', rating: 4.8, funFact: 'One of the most expensive shopping districts in the world.'),
      Shop(id: 's2', name: 'Akihabara', description: 'Center for anime and electronics.', imageUrl: 'assets/shop/akihabara.png', location: 'Tokyo', category: 'Electronics', rating: 4.6),
      Shop(id: 's3', name: 'Shinsaibashi-suji', description: 'Prime shopping arcade in Osaka.', imageUrl: 'assets/shop/shinsaibashi.png', location: 'Osaka', category: 'Arcade', rating: 4.5),
      Shop(id: 's4', name: 'Nakamise-dori', description: 'Traditional souvenirs near Senso-ji Temple.', imageUrl: 'assets/shop/nakamise.png', location: 'Tokyo', category: 'Souvenirs', rating: 4.4),
      Shop(id: 's5', name: 'Omotesando', description: 'Trendy boutiques and architecture.', imageUrl: 'assets/shop/omotesando.png', location: 'Tokyo', category: 'Boutique', rating: 4.7),
    ];

    // List tampilan toko
    return ListView.builder(
      itemCount: shops.length,
      itemBuilder: (context, index) {
        final shop = shops[index];
        final place = Place(
          id: shop.id,
          name: shop.name,
          description: shop.description,
          imagePath: shop.imageUrl,
          rating: shop.rating,
        );

        return AnimatedListItem(
          index: index,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF512DA8).withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gambar
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShopDetailPage(shop: shop)),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Image.asset(
                      shop.imageUrl,
                      width: 130,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Detail toko
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shop.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(shop.description,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            RatingStars(rating: shop.rating, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              shop.rating.toString(),
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        InfoRow(
                          icon: Icons.location_on_outlined,
                          text: shop.location,
                          iconColor: Colors.white70,
                          textColor: Colors.white70,
                        ),
                        InfoRow(
                          icon: Icons.category_outlined,
                          text: 'Category: ${shop.category}',
                          iconColor: Colors.white70,
                          textColor: Colors.white70,
                        ),
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
    );
  }
}
