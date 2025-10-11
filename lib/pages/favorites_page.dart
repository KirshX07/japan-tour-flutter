import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/pages/animated_page_header.dart';
import '../copyright_footer.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AnimatedPageHeader(title: "Favorites"),
        Expanded(
          child: Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final favorites = favoritesProvider.favoritePlaces;

              if (favorites.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final place = favorites[index];
                  return _buildFavoriteItem(context, place, favoritesProvider);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteItem(
      BuildContext context, Place place, FavoritesProvider favoritesProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar kiri
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.asset(
              place.imagePath,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),

          // Konten kanan
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    place.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        place.rating.toString(),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.event, color: Colors.blueAccent),
                        tooltip: 'Add to calendar',
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.redAccent),
                        tooltip: 'Remove from favorites',
                        onPressed: () {
                          favoritesProvider.toggleFavorite(place);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${place.name} removed from favorites'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: Colors.deepPurple,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              size: 100,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              "No Favorites Yet!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Tap the ❤️ icon on any place to save it here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Poppins',
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 50),
            const CopyrightFooter(),
          ],
        ),
      ),
    );
  }
}
