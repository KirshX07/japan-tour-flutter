import 'package:flutter/material.dart';

class BookingItem {
  final String name;
  final double price;

  BookingItem({required this.name, required this.price});
}

class BookingCategory {
  final String name;
  final List<BookingItem> items;

  BookingCategory({required this.name, required this.items});
}

final List<BookingCategory> bookingData = [
  BookingCategory(name: 'Hotel', items: [
    BookingItem(name: 'Luxury Suite', price: 300.0),
    BookingItem(name: 'Standard Room', price: 150.0),
    BookingItem(name: 'Budget Room', price: 80.0),
  ]),
  BookingCategory(name: 'Experience', items: [
    BookingItem(name: 'Tea Ceremony', price: 50.0),
    BookingItem(name: 'Samurai Class', price: 120.0),
    BookingItem(name: 'City Tour', price: 75.0),
  ]),
  BookingCategory(name: 'Food & Drink', items: [
    BookingItem(name: 'Kaiseki Dinner', price: 100.0),
    BookingItem(name: 'Ramen Tasting', price: 30.0),
    BookingItem(name: 'Sake Brewery Tour', price: 45.0),
  ]),
  BookingCategory(name: 'Transport', items: [
    BookingItem(name: 'Shinkansen Ticket', price: 120.0),
    BookingItem(name: 'Private Car (8h)', price: 400.0),
    BookingItem(name: 'Airport Limousine Bus', price: 35.0),
  ]),
  BookingCategory(name: 'Event', items: [
    BookingItem(name: 'Concert VIP Ticket', price: 250.0),
    BookingItem(name: 'Sumo Tournament Seat', price: 90.0),
    BookingItem(name: 'Art Exhibition Entry', price: 25.0),
  ]),
  BookingCategory(name: 'Amusement', items: [
    BookingItem(name: 'Theme Park Day Pass', price: 80.0),
    BookingItem(name: 'Aquarium Ticket', price: 30.0),
  ]),
  BookingCategory(name: 'Shop', items: [
    BookingItem(name: 'Shopping Voucher \$50', price: 50.0),
    BookingItem(name: 'Shopping Voucher \$100', price: 100.0),
  ]),
];

/// A class to hold the details of a confirmed booking.
class ConfirmedBooking {
  final String id;
  final String category;
  final String item;
  final int quantity;
  final double price;
  final DateTime date;
  final TimeOfDay time;
  final String status;

  ConfirmedBooking({
    required this.id,
    required this.category,
    required this.item,
    required this.quantity,
    required this.price,
    required this.date,
    required this.time,
    required this.status,
  });

  // Method to convert a ConfirmedBooking instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'item': item,
        'quantity': quantity,
        'price': price,
        'date': date.toIso8601String(),
        'time': '${time.hour}:${time.minute}',
        'status': status,
      };

  // Factory constructor to create a ConfirmedBooking instance from a JSON map.
  factory ConfirmedBooking.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['time'] as String).split(':');
    return ConfirmedBooking(
      id: json['id'],
      category: json['category'],
      item: json['item'],
      quantity: json['quantity'],
      price: json['price'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])),
      status: json['status'],
    );
  }

  ConfirmedBooking copyWith({
    String? id,
    String? category,
    String? item,
    int? quantity,
    double? price,
    DateTime? date,
    TimeOfDay? time,
    String? status,
  }) {
    return ConfirmedBooking(
      id: id ?? this.id,
      category: category ?? this.category,
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
    );
  }
}