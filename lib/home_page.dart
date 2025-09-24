import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/copyright_footer.dart';
import 'package:flutter_app/models/place_model.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/pages/amusement_page.dart';
import 'package:flutter_app/pages/favorites_page.dart';
import 'package:flutter_app/pages/event_page.dart';
import 'package:flutter_app/pages/experience_page.dart';
import 'package:flutter_app/pages/food_and_drink_page.dart';
import 'package:flutter_app/pages/hotel_page.dart';
import 'package:flutter_app/pages/schedule_page.dart';
import 'package:flutter_app/pages/profile_page.dart';
import 'package:flutter_app/pages/help_and_emergency_page.dart';
import 'package:flutter_app/pages/shop_page.dart';
import 'package:flutter_app/pages/transport_page.dart';
import 'package:flutter_app/pages/waypoint_page.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;

  final List<Widget> _pages = [
    const HomeContent(),
    const FavoritesPage(),
    const ProfilePage(),
    const SchedulePage(),
    const HelpAndEmergencyPage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrangeAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Planner"),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help/Emergency"),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _currentIndex = 3),
        label: const Text('Planner'),
        icon: const Icon(Icons.event),
      ),
    );
  }
}

// ================= HOME CONTENT =================

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  // Menu items (Discover / Explore)
  final List<Map<String, dynamic>> menuItems = [
    {"icon": Icons.hotel, "label": "Hotel", "page": const HotelPage()},
    {
      "icon": Icons.flight_takeoff,
      "label": "Transport",
      "page": const TransportPage()
    },
    {
      "icon": Icons.place,
      "label": "Waypoint",
      "page": const WaypointPage()
    },
    {
      "icon": Icons.fastfood,
      "label": "Food & Drink",
      "page": const FoodDrinkPage()
    },
    {
      "icon": Icons.theaters,
      "label": "Culture / Experience",
      "page": const ExperiencePage()
    },
    {"icon": Icons.event, "label": "Event", "page": const EventPage()},
    {
      "icon": Icons.toys,
      "label": "Amusement",
      "page": const AmusementPage()
    },
    {"icon": Icons.shopping_bag, "label": "Shop", "page": const ShopPage()},
  ];

  final List<Place> popularPlaces = const [
    Place(id: 'p1', name: 'Fushimi Inari, Kyoto', imagePath: 'assets/popular/kyoto.png', description: 'Iconic shrine with thousands of torii gates.'),
    Place(id: 'p2', name: 'Shibuya Crossing, Tokyo', imagePath: 'assets/popular/shibuya.png', description: 'The world\'s busiest intersection.'),
    Place(id: 'p3', name: 'Hakone Onsen', imagePath: 'assets/popular/hakone.png', description: 'Famous for hot springs and nature.'),
    Place(id: 'p4', name: 'Mount Fuji', imagePath: 'assets/popular/mtfuji.png', description: 'Japan\'s iconic, sacred mountain.'),
  ];

  final List<Map<String, String>> eventsAndPromos = const [
    {"title": "Tokyo Summer Festival", "image": "assets/events/matsuri.png"},
    {"title": "Winter Sale", "image": "assets/events/sale.png"},
    {"title": "Live Concert Shinjuku", "image": "assets/events/concert.png"},
  ];

  final List<Map<String, String>> souvenirs = const [
    {"title": "Keychain", "image": "assets/souvenirs/keychain.png"},
    {"title": "Postcard", "image": "assets/souvenirs/postcard.png"},
    {"title": "Magnet", "image": "assets/souvenirs/magnet.png"},
  ];

  // Tambahan contoh data 
  final List<Map<String, String>> homeList = const [
    {"title": "Tokyo Tower", "subtitle": "Popular landmarks in Tokyo"},
    {"title": "Kyoto Temple", "subtitle": "Historical temple in Kyoto"},
    {"title": "Osaka Castle", "subtitle": "Iconic Japanese palace"},
    {"title": "Nara Deer Park", "subtitle": "Nara's famous deer park"},
    {"title": "Sapporo Snow Festival", "subtitle": "Winter snow festival"},
  ];

  late final PageController _popularController;
  late final PageController _seasonController;
  Timer? _popularAutoScroll;
  Timer? _seasonAutoScroll;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _popularController = PageController(viewportFraction: 0.78);
    _seasonController = PageController(viewportFraction: 0.88);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0.96,
      upperBound: 1.04,
    )..repeat(reverse: true);

    // Auto-scroll popular carousel
    _popularAutoScroll = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_popularController.hasClients) {
        final next = _popularController.page!.round() + 1;
        _popularController.animateToPage(
          next % popularPlaces.length,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });

    // Auto-scroll seasonal highlight
    _seasonAutoScroll = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_seasonController.hasClients) {
        final next = _seasonController.page!.round() + 1;
        _seasonController.animateToPage(
          next % 4, // jumlah season = 4
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _popularAutoScroll?.cancel();
    _seasonAutoScroll?.cancel();
    _popularController.dispose();
    _seasonController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // quick palette
  Gradient get _warmGradient => const LinearGradient(
        colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  Gradient get _coolGradient => const LinearGradient(
        colors: [Color(0xFF42A5F5), Color(0xFF7E57C2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.grey.shade50,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeroBanner(),
            const SizedBox(height: 18),

            _buildSectionTitle("Discover / Explore"),
            _buildAnimatedMenuGrid(),

            const SizedBox(height: 18),
            _buildSectionTitle("Popular"),
            _buildPopularCarousel(),

            const SizedBox(height: 18),
            _buildSectionTitle("Seasonal Highlight"),
            _buildSeasonalHighlight(),

            const SizedBox(height: 18),
            _buildSectionTitle("Event & Promo"),
            _buildEventsCarousel(),

            const SizedBox(height: 18),
            _buildSectionTitle("Souvenir Collection"),
            _buildSouvenirRow(),

            const SizedBox(height: 18),
            _buildSectionTitle("Recommendation"),
            _buildHomeList(),

            const CopyrightFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Hero(
      tag: 'banner',
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: _warmGradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ScaleTransition(
                  scale: _pulseController,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _coolGradient,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.explore,
                          size: 44, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Welcome to Japan Tour App',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Discover, explore and enjoy — seasonal highlights & local events',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 24,
            decoration: BoxDecoration(
              gradient: _coolGradient,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMenuGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8),
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        final color = Colors.primaries[index % Colors.primaries.length];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 350 + (index * 80)),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 24 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (item['page'] != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => item['page']),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item['label']} page not implemented yet.')),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [color.shade200, color.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: color.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 6))
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Icon(item['icon'], color: color.shade700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['label'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopularCarousel() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _popularController,
        itemCount: popularPlaces.length,
        itemBuilder: (context, index) {
          final place = popularPlaces[index];
          return _PopularPlaceCard(place: place);
        },
      ),
    );
  }

  Widget _buildHomeList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homeList.length,
      itemBuilder: (context, index) {
        final item = homeList[index];
        return _buildAnimatedItem(
          index: index,
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepOrangeAccent,
                child: Text(
                  item['title']![0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(item['title']!),
              subtitle: Text(item['subtitle']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item['title']} clicked')),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedItem({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildSeasonalHighlight() {
    final seasons = [
      {"label": "Spring", "image": "assets/seasons/spring.png"},
      {"label": "Summer", "image": "assets/seasons/summer.png"},
      {"label": "Autumn", "image": "assets/seasons/autumn.png"},
      {"label": "Winter", "image": "assets/seasons/winter.png"},
    ];

    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _seasonController,
        itemCount: seasons.length,
        itemBuilder: (context, index) {
          final item = seasons[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item['label']} selected')),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(item['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Gradient Overlay
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                    ),
                    // Label Season
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Text(
                        item['label']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventsCarousel() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: eventsAndPromos.length,
        itemBuilder: (context, index) {
          final item = eventsAndPromos[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Container(
                    width: 220,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(item['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 220,
                    color: Colors.black.withOpacity(0.30),
                    child: Center(
                      child: Text(
                        item['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSouvenirRow() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: souvenirs.length,
        itemBuilder: (context, index) {
          final item = souvenirs[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(item['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['title']!,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}

class _PopularPlaceCard extends StatelessWidget {
  const _PopularPlaceCard({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    // Watch for changes in the favorites provider
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isFavorited = favoritesProvider.isFavorite(place);

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          // TODO: Navigate to a detail page for the place
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${place.name} selected')),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                place.imagePath,
                fit: BoxFit.cover,
              ),
              // Gradient overlay for text readability
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
              ),
              // Place name
              Positioned(
                left: 12,
                bottom: 12,
                right: 12,
                child: Text(
                  place.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              // Favorite button
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.white,
                    ),
                    onPressed: () => favoritesProvider.toggleFavorite(place),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
