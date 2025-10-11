import 'package:flutter/material.dart';
import 'package:flutter_app/pages/experience_page.dart';
import 'package:flutter_app/detailpage/generic_detail_page.dart';
import 'package:flutter_app/models/place_model.dart';
import '../widgets/shared_widgets.dart'; // Import shared widgets

class ExperienceDetailPage extends StatelessWidget {
  final Experience experience;

  const ExperienceDetailPage({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    final place = Place(
      id: experience.id,
      name: experience.name,
      description: experience.description,
      imagePath: experience.imageUrl,
    );

    return GenericDetailPage(
      place: place,
      funFact: experience.funFact,
      detailWidgets: [
        InfoRow(icon: Icons.category_outlined, text: 'Type: ${experience.type}'),
        InfoRow(icon: Icons.attach_money, text: 'Price: ¥${experience.price.toStringAsFixed(0)}'), // Tetap menggunakan format ini jika tidak perlu simbol mata uang lengkap
        InfoRow(icon: Icons.star, text: 'Rating: ${experience.rating} / 5.0'),
      ],
    );
  }
}