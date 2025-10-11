import 'package:flutter/material.dart';
import 'package:flutter_app/pages/amusement_page.dart';
import 'package:flutter_app/detailpage/generic_detail_page.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:intl/intl.dart';
import '../widgets/shared_widgets.dart'; // Import shared widgets

class AmusementDetailPage extends StatelessWidget {
  final Amusement amusement;

  const AmusementDetailPage({super.key, required this.amusement});

  @override
  Widget build(BuildContext context) {
    // Konversi dari Amusement ke Place agar cocok dengan GenericDetailPage
    final place = Place(
      id: amusement.id,
      name: amusement.name,
      description: amusement.description,
      imagePath: amusement.imageUrl,
    );

    return GenericDetailPage(
      place: place,
      funFact: amusement.funFact,
      detailWidgets: [
        InfoRow(icon: Icons.attach_money, text: 'Entry Fee: ${NumberFormat.currency(locale: 'ja_JP', symbol: '¥', decimalDigits: 0).format(amusement.price)}'),
        InfoRow(icon: Icons.star, text: 'Rating: ${amusement.rating} / 5.0'),
      ],
    );
  }
}