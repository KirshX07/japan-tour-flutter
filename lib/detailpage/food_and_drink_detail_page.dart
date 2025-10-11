import 'package:flutter/material.dart';
import 'package:flutter_app/pages/food_and_drink_page.dart';
import 'package:flutter_app/detailpage/generic_detail_page.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/widgets/shared_widgets.dart';

class FoodDrinkDetailPage extends StatelessWidget {
  final FoodDrink foodDrink;

  const FoodDrinkDetailPage({super.key, required this.foodDrink});

  @override
  Widget build(BuildContext context) {
    final place = Place(
      id: foodDrink.id,
      name: foodDrink.name,
      description: foodDrink.description,
      imagePath: foodDrink.imageUrl,
    );

    return GenericDetailPage(
      place: place,
      funFact: foodDrink.funFact,
      detailWidgets: [
        InfoRow(icon: Icons.restaurant_menu, text: 'Cuisine: ${foodDrink.cuisine}'),
        InfoRow(icon: Icons.attach_money, text: 'Approx. Price: ¥${foodDrink.price.toStringAsFixed(0)}'),
        InfoRow(icon: Icons.star, text: 'Rating: ${foodDrink.rating} / 5.0'),
      ],
    );
  }
}