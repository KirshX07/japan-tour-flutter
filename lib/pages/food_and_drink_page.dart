// lib/pages/food_and_drink_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'base_page.dart';
import 'package:provider/provider.dart';

class FoodDrink extends Destination {
  final String _cuisine;
  final double price;
  final double rating;

  FoodDrink({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required String cuisine,
    required this.price,
    required this.rating,
  })  : _cuisine = cuisine,
        super(id, name, description, imageUrl);
  String get cuisine => _cuisine;
}

class FoodDrinkPage extends BasePage {
  const FoodDrinkPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    final foods = [
      FoodDrink(id: 'fd1', name: 'Sushi Dai', description: 'Famous sushi at Toyosu Market.', imageUrl: 'assets/food/sushi.png', cuisine: 'Sushi Restaurant', price: 4000, rating: 4.5),
      FoodDrink(id: 'fd2', name: 'Ichiran Ramen', description: 'A popular ramen chain with customizable bowls.', imageUrl: 'assets/food/ramen.png', cuisine: 'Ramen Shop', price: 1500, rating: 4.2),
      FoodDrink(id: 'fd3', name: 'Dotonbori Street Food', description: 'Try takoyaki and okonomiyaki in Osaka.', imageUrl: 'assets/food/dotonbori.png', cuisine: 'Street Food', price: 800, rating: 4.0),
      FoodDrink(id: 'fd4', name: 'Nishiki Market', description: 'Kyoto\'s kitchen, offering various local foods.', imageUrl: 'assets/food/nishiki.png', cuisine: 'Market', price: 1000, rating: 4.3),
      FoodDrink(id: 'fd5', name: 'Golden Gai', description: 'Tiny, atmospheric bars in Shinjuku.', imageUrl: 'assets/food/goldengai.png', cuisine: 'Bar', price: 2000, rating: 3.8),
    ];
    return ListView.builder(
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        final place = Place(
          id: food.id,
          name: food.name,
          description: food.description,
          imagePath: food.imageUrl,
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
                food.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(food.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(food.description, style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.restaurant_menu, food.cuisine),
                    const SizedBox(height: 6),
                    _buildInfoRow(Icons.attach_money, 'Approx. ¥${food.price.toStringAsFixed(0)}'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildRatingStars(food.rating),
                        const SizedBox(width: 8),
                        Text(food.rating.toString(), style: TextStyle(color: Colors.grey.shade700)),
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