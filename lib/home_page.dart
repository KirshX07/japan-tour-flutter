import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/animated_page_header.dart';
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
import 'package:flutter_app/pages/place_detail_page.dart';
import 'package:flutter_app/widgets/shared_widgets.dart';
import 'package:flutter_app/widgets/page_transitions.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final List<Widget> _pages;
  double _pageOffset = 0.0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeContent(username: widget.username),
      const FavoritesPage(),
      ProfilePage(username: widget.username),
      const SchedulePage(),
      const HelpAndEmergencyPage(),
    ];
    _pageController = PageController(initialPage: _currentIndex);
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF4A148C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PageView.builder(
          controller: _pageController,
          itemCount: _pages.length,
          itemBuilder: (context, index) {
            final page = _pages[index];
            final offset = _pageOffset - index;

            // A value that's 1 when the page is active, and goes to 0 when it's one page away.
            final double visibility = (1 - offset.abs()).clamp(0.0, 1.0);

            // Apply a subtle scale and fade effect to pages that are not in focus.
            return Opacity(
              opacity: Curves.easeOut.transform(visibility),
              child: Transform.scale(
                scale: 1.0 - (offset.abs() * 0.1),
                alignment: Alignment.center,
                child: page,
              ),
            );
          },
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onNavItemTapped(2), // Arahkan ke Profile (index 2)
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          elevation: 4.0,
          shape: const CircleBorder(),
          child: const Icon(Icons.person), // Ganti ikon menjadi Profile
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: const Color(0xFF1A237E).withOpacity(0.8),
      elevation: 10,
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(Icons.home_outlined, Icons.home, 0, "Home"),
          _buildNavItem(Icons.favorite_border, Icons.favorite, 1, "Favorites"),
          const SizedBox(width: 48), // The space for the FAB
          _buildNavItem(Icons.event_note_outlined, Icons.event_note, 3, "Planner"),
          _buildNavItem(Icons.help_outline, Icons.help, 4, "Help"),
        ],
      ),
    );
  }

  void _onNavItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildNavItem(IconData unselectedIcon, IconData selectedIcon, int index, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? Colors.white : Colors.white.withOpacity(0.7);

    return InkWell(
      onTap: () => _onNavItemTapped(index),
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.white.withOpacity(0.1),
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          AnimatedScale(
            scale: isSelected ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Icon(isSelected ? selectedIcon : unselectedIcon, color: color, size: 24.0),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            height: 3,
            width: isSelected ? 20 : 0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ================= HOME CONTENT =================

class HomeContent extends StatefulWidget {
  final String username;
  const HomeContent({super.key, required this.username});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
  late AnimationController _pulseController;
  Timer? _popularAutoScroll;
  Timer? _seasonAutoScroll;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() => _searchQuery = _searchController.text.toLowerCase()));
    _popularController = PageController(viewportFraction: 0.78);
    _seasonController = PageController(viewportFraction: 0.88);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0.96,
      upperBound: 1.04,
    )..repeat(reverse: true);

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
    _seasonAutoScroll = Timer.periodic(const Duration(seconds: 4), (timer) {
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeroBanner(),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildSectionTitle("Discover / Explore"),
          _buildAnimatedMenuGrid(),
          const SizedBox(height: 20),
          _buildSectionTitle("Popular Places"),
          _buildPopularCarousel(),
          const SizedBox(height: 20),
          _buildSectionTitle("Seasonal Highlight"),
          _buildSeasonalHighlight(),
          const SizedBox(height: 20),
          _buildSectionTitle("Event & Promo"),
          _buildEventsCarousel(),
          const SizedBox(height: 20),
          _buildSectionTitle("Souvenir Collection"),
          _buildSouvenirRow(),
          const SizedBox(height: 20),
          _buildSectionTitle("Recommendation"),
          _buildHomeList(),
          const SizedBox(height: 20),
          const CopyrightFooter(),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A148C), Color(0xFF7E57C2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 6))
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black26],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ScaleTransition(
                  scale: _pulseController,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF1A237E), Color(0xFF4A148C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(Icons.explore, color: Colors.white, size: 40),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome, ${widget.username}!',
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins',)),
                      const SizedBox(height: 6),
                      const Text('Explore Japan — discover, travel, and enjoy!',
                          style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Poppins',)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.black87, fontFamily: 'Poppins'),
      decoration: InputDecoration(
        hintText: 'Search recommendations...',
        hintStyle: TextStyle(color: Colors.grey.shade600, fontFamily: 'Poppins'),
        prefixIcon: const Icon(Icons.search, color: Colors.deepPurpleAccent),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Poppins')),
    );
  }

  Widget _buildAnimatedMenuGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (index * 80)),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(offset: Offset(0, (1 - value) * 20), child: child),
            );
          },
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => item['page']));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF512DA8), Color(0xFF9575CD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(0, 4))],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'], color: Colors.white, size: 28),
                  const SizedBox(height: 8),
                  Text(item['label'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12, fontFamily: 'Poppins')),
                ],
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
        itemBuilder: (context, index) => _PopularPlaceCard(place: popularPlaces[index]),
      ),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(item['image']!, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Text(
                      item['label']!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Poppins'),
                    ),
                  ),
                ],
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
                      image: DecorationImage(image: AssetImage(item['image']!), fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    width: 220,
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.35)),
                    child: Center(
                      child: Text(
                        item['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
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
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: souvenirs.length,
        itemBuilder: (context, index) {
          final item = souvenirs[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(image: AssetImage(item['image']!), fit: BoxFit.cover),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['title']!,
                  style: const TextStyle(fontSize: 13, color: Colors.white70, fontFamily: 'Poppins'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeList() {
    final filteredList = homeList.where((item) =>
      item['title']!.toLowerCase().contains(_searchQuery) ||
      item['subtitle']!.toLowerCase().contains(_searchQuery)
    ).toList();

    if (_searchQuery.isNotEmpty && filteredList.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text("No recommendations found.", style: TextStyle(color: Colors.white70, fontFamily: 'Poppins')),
      ));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return AnimatedListItem(
          index: index,
          child: Card(
            color: const Color(0xFF4A148C).withOpacity(0.4),
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(item['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
              subtitle: Text(item['subtitle']!, style: const TextStyle(color: Colors.white70, fontFamily: 'Poppins')),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
              onTap: () {},
            ),
          ),
        );
      },
    );
  }
}

class _PopularPlaceCard extends StatefulWidget {
  final Place place;
  const _PopularPlaceCard({required this.place});

  @override
  State<_PopularPlaceCard> createState() => _PopularPlaceCardState();
}

class _PopularPlaceCardState extends State<_PopularPlaceCard> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final isFav = favorites.isFavorite(widget.place);

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isTapped = true),
        onTapCancel: () => setState(() => _isTapped = false),
        onTapUp: (_) {
          setState(() => _isTapped = false);
          Navigator.push(
            context,
            FadePageRoute(child: PlaceDetailPage(place: widget.place)),
          );
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          scale: _isTapped ? 0.95 : 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: widget.place.id,
                  child: Image.asset(widget.place.imagePath, fit: BoxFit.cover),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Text(
                    widget.place.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Poppins'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.redAccent : Colors.white),
                      onPressed: () => favorites.toggleFavorite(widget.place),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
