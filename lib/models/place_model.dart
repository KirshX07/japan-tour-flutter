class Place {
  final String id;
  final String name;
  final String imagePath;
  final String description;
  final String? bestTimeToVisit;
  final String? peakSeason;
  final String? longDescription;
  final double? rating; // ✅ Tambahkan rating
  final String? bookingCategoryName;
  final String? bookingItemName;

  const Place({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    this.bestTimeToVisit,
    this.peakSeason,
    this.longDescription,
    this.rating, // ✅ tambahkan ke konstruktor
    this.bookingCategoryName,
    this.bookingItemName,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imagePath': imagePath,
        'description': description,
        'bestTimeToVisit': bestTimeToVisit,
        'peakSeason': peakSeason,
        'longDescription': longDescription,
        'rating': rating, // ✅ simpan ke JSON
      };

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        id: json['id'] as String,
        name: json['name'] as String,
        imagePath: json['imagePath'] as String,
        description: json['description'] as String,
        bestTimeToVisit: json['bestTimeToVisit'] as String?,
        peakSeason: json['peakSeason'] as String?,
        longDescription: json['longDescription'] as String?,
        rating: (json['rating'] as num?)?.toDouble(), // ✅ pastikan aman
      );
}
