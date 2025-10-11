import 'package:flutter/material.dart';
import 'package:flutter_app/pages/hotel_page.dart';
import 'package:flutter_app/detailpage/generic_detail_page.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:intl/intl.dart';
import '../widgets/shared_widgets.dart'; // Import shared widgets

class HotelDetailPage extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailPage({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final place = Place(
      id: hotel.id,
      name: hotel.name,
      description: hotel.description,
      imagePath: hotel.imageUrl,
      bestTimeToVisit: hotel.bestTimeToVisit,
      peakSeason: hotel.peakSeason,
      longDescription: hotel.longDescription,
    );

    return GenericDetailPage(
      place: place,
      funFact: hotel.funFact,
      detailWidgets: [
        InfoRow(icon: Icons.attach_money, text: 'Price per Night: ${NumberFormat.currency(locale: 'ja_JP', symbol: '¥', decimalDigits: 0).format(hotel.price)}'),
        InfoRow(icon: Icons.star, text: 'Rating: ${hotel.rating} / 5.0'),
      ],
    );
  }
}