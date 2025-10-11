// lib/pages/waypoint_page.dart
import 'package:flutter/material.dart';
import 'base_page.dart';
import '../detailpage/waypoint_detail_page.dart';

// Model for a city waypoint, inheriting from Destination
class Waypoint extends Destination {
  Waypoint({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
  }) : super(id, name, description, imageUrl);
}

// Widget for the Waypoint page
class WaypointPage extends BasePage {
  const WaypointPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    // List of major cities in Japan
    final waypoints = [
      Waypoint(
        id: 'w1',
        name: 'Tokyo',
        description: 'The bustling and modern capital of Japan.',
        imageUrl: 'assets/waypoints/tokyo.png', // Replace with your image path
      ),
      Waypoint(
        id: 'w2',
        name: 'Osaka',
        description: 'Famous for its nightlife and street food.',
        imageUrl: 'assets/waypoints/osaka.png', // Replace with your image path
      ),
      Waypoint(
        id: 'w3',
        name: 'Kyoto',
        description: 'Former imperial capital, full of temples.',
        imageUrl: 'assets/waypoints/kyoto.png', // Replace with your image path
      ),
      Waypoint(
        id: 'w4',
        name: 'Sapporo',
        description: 'Known for its snowy winters and ramen.',
        imageUrl: 'assets/waypoints/sapporo.png', // Replace with your image path
      ),
      Waypoint(
        id: 'w5',
        name: 'Fukuoka',
        description: 'A vibrant city on the island of Kyushu.',
        imageUrl: 'assets/waypoints/fukuoka.png', // Replace with your image path
      ),
    ];

    // Using GridView for a more attractive layout
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 4, // Adjusting the card aspect ratio
      ),
      itemCount: waypoints.length,
      itemBuilder: (context, index) {
        final waypoint = waypoints[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WaypointDetailPage(waypoint: waypoint),
              ),
            );
          },
          child: Card(
            color: const Color(0xFF4A148C).withOpacity(0.3),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                Image.asset(
                  waypoint.imageUrl,
                  fit: BoxFit.cover,
                ),
                // Gradient to make the text more readable
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // City name and description
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        waypoint.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(blurRadius: 6, color: Colors.black87)],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        waypoint.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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