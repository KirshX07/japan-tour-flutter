import 'package:flutter/material.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:provider/provider.dart';
import 'base_page.dart';
import '../detailpage/food_and_drink_detail_page.dart';
import '../widgets/shared_widgets.dart';

class FoodDrink extends Destination {
  final String _cuisine;
  final double price;
  final double rating;
  final String? funFact;

  FoodDrink({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required String cuisine,
    required this.price,
    required this.rating,
    this.funFact,
  })  : _cuisine = cuisine,
        super(id, name, description, imageUrl);

  String get cuisine => _cuisine;
}

class FoodDrinkPage extends BasePage {
  const FoodDrinkPage({super.key});

  @override
  String get pageTitle => 'Food & Drink';

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

    final foods = [
      FoodDrink(
        id: 'fd1',
        name: 'Sushi Dai',
        description: 'Famous sushi at Toyosu Market.',
        imageUrl: 'assets/food/sushi.png',
        cuisine: 'Sushi Restaurant',
        price: 4000,
        rating: 4.5,
        funFact:
            'People used to line up for hours before dawn just to eat at the original Tsukiji location.',
      ),
      FoodDrink(
        id: 'fd2',
        name: 'Ichiran Ramen',
        description: 'A popular ramen chain with customizable bowls.',
        imageUrl: 'assets/food/ramen.png',
        cuisine: 'Ramen Shop',
        price: 1500,
        rating: 4.2,
        funFact:
            'Ichiran is famous for its “flavor concentration booths,” where you eat alone to focus on the ramen.',
      ),
      FoodDrink(
        id: 'fd3',
        name: 'Dotonbori Street Food',
        description: 'Try takoyaki and okonomiyaki in Osaka.',
        imageUrl: 'assets/food/dotonbori.png',
        cuisine: 'Street Food',
        price: 800,
        rating: 4.0,
        funFact:
            'The concept of “kuidaore” (eat until you drop) originated in Dotonbori.',
      ),
      FoodDrink(
        id: 'fd4',
        name: 'Nishiki Market',
        description: 'Kyoto\'s kitchen, offering local foods.',
        imageUrl: 'assets/food/nishiki.png',
        cuisine: 'Market',
        price: 1000,
        rating: 4.3,
        funFact:
            'Some shops in Nishiki Market have been run by the same family for centuries.',
      ),
      FoodDrink(
        id: 'fd5',
        name: 'Golden Gai',
        description: 'Tiny, atmospheric bars in Shinjuku.',
        imageUrl: 'assets/food/goldengai.png',
        cuisine: 'Bar',
        price: 2000,
        rating: 3.8,
        funFact:
            'This small area has over 200 bars, many seating only a handful of guests.',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        final place = Place(
          id: food.id,
          name: food.name,
          description: food.description,
          imagePath: food.imageUrl,
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
                              FoodDrinkDetailPage(foodDrink: food)),
                    );
                  },
                  child: Hero(
                    tag: food.id,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      child: Image.asset(
                        food.imageUrl,
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
                          food.name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          food.description,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            RatingStars(rating: food.rating, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              food.rating.toString(),
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        InfoRow(
                          icon: Icons.restaurant_menu,
                          text: food.cuisine,
                          iconColor: Colors.white70,
                          textColor: Colors.white70,
                        ),
                        InfoRow(
                          icon: Icons.attach_money,
                          text:
                              'Approx. ¥${food.price.toStringAsFixed(0)}',
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
