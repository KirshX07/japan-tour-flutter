import 'package:flutter/material.dart';
import 'package:flutter_app/pages/waypoint_page.dart';
import 'package:flutter_app/detailpage/generic_detail_page.dart';
import 'package:flutter_app/models/place_model.dart';
import '../widgets/shared_widgets.dart';

class WaypointDetailPage extends StatelessWidget {
  final Waypoint waypoint;

  const WaypointDetailPage({super.key, required this.waypoint});

  @override
  Widget build(BuildContext context) {
    // Konversi dari Waypoint ke Place agar sesuai dengan GenericDetailPage
    final place = Place(
      id: waypoint.id,
      name: waypoint.name,
      description: waypoint.description,
      imagePath: waypoint.imageUrl,
    );

    return GenericDetailPage(
      place: place,
      // Karena model Waypoint tidak memiliki detail tambahan,
      // kita bisa memberikan widget informasi umum atau daftar kosong.
      detailWidgets: const [
        InfoRow(icon: Icons.location_city, text: 'Major City in Japan', iconColor: Colors.white70, textSize: 16),
      ],
    );
  }
}