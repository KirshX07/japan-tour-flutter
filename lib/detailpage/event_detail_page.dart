import 'package:flutter/material.dart';
import 'package:flutter_app/pages/event_page.dart';
import 'package:flutter_app/detailpage/generic_detail_page.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:intl/intl.dart';
import '../widgets/shared_widgets.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Konversi dari Event ke Place agar cocok dengan GenericDetailPage
    final place = Place(
      id: event.id,
      name: event.name,
      description: event.description,
      imagePath: event.imageUrl,
      rating: event.rating,
    );

    return GenericDetailPage(
      place: place,
      funFact: event.funFact,
      detailWidgets: [
        InfoRow(icon: Icons.calendar_today, text: 'Date: ${DateFormat.yMMMMd().format(event.date)}'),
        InfoRow(icon: Icons.location_on, text: 'Location: ${event.location}'),
        InfoRow(icon: Icons.category_outlined, text: 'Category: ${event.category}'),
      ],
    );
  }
}