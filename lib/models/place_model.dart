class Place {
  final String id;
  final String name;
  final String imagePath;
  final String description;

  const Place({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
  });

  /// Mengubah instance Place menjadi Map, yang dapat di-encode ke JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imagePath': imagePath,
        'description': description,
      };

  /// Membuat instance Place dari Map (setelah di-decode dari JSON).
  factory Place.fromJson(Map<String, dynamic> json) => Place(
        id: json['id'] as String,
        name: json['name'] as String,
        imagePath: json['imagePath'] as String,
        description: json['description'] as String,
      );
}