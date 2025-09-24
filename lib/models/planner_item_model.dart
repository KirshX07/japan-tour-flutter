import 'package:flutter_app/models/place_model.dart';

class PlannerItem {
  final Place place;
  final DateTime date;
  final String id; // Unique ID for the planner item itself

  PlannerItem({
    required this.place,
    required this.date,
    // A simple unique ID based on place and date to prevent duplicates on the same day
  }) : id = '${place.id}_${date.toIso8601String().substring(0, 10)}';

  /// Converts a PlannerItem instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'place': place.toJson(),
        'date': date.toIso8601String(),
      };

  /// Creates a PlannerItem instance from a JSON map.
  factory PlannerItem.fromJson(Map<String, dynamic> json) => PlannerItem(
        place: Place.fromJson(json['place']),
        date: DateTime.parse(json['date']),
      );

  // Override equals and hashCode for proper list management (e.g., contains, remove).
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlannerItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}