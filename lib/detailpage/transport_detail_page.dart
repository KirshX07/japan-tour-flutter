import 'package:flutter/material.dart';
import 'package:flutter_app/pages/transport_page.dart';
import 'package:flutter_app/detailpage/generic_detail_page.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:intl/intl.dart';
import '../widgets/shared_widgets.dart';

class TransportDetailPage extends StatelessWidget {
  final Transport transport;

  const TransportDetailPage({super.key, required this.transport});

  @override
  Widget build(BuildContext context) {
    final place = Place(
      id: transport.id,
      name: transport.name,
      description: transport.description,
      imagePath: transport.imageUrl,
      bestTimeToVisit: transport.bestTimeToVisit,
      peakSeason: transport.peakSeason,
    );

    return GenericDetailPage(
      place: place,
      funFact: transport.funFact,
      detailWidgets: [
        InfoRow(icon: Icons.attach_money, text: 'Cost: ${NumberFormat.currency(locale: 'ja_JP', symbol: '¥', decimalDigits: 0).format(transport.cost)}'),
        InfoRow(icon: Icons.star, text: 'Rating: ${transport.rating} / 5.0'),
      ],
    );
  }
}