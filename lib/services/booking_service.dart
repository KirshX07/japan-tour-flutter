import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/models/booking_model.dart';

class BookingHistoryService {
  static const String _bookingKey = 'confirmed_bookings';

  // Save a new booking
  static Future<void> saveBooking(ConfirmedBooking booking) async {
    final prefs = await SharedPreferences.getInstance();
    final bookings = await loadBookings();
    bookings.add(booking);
    await _saveBookingsToPrefs(prefs, bookings);
  }

  // Load all bookings
  static Future<List<ConfirmedBooking>> loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookingsString = prefs.getString(_bookingKey);
    if (bookingsString != null && bookingsString.isNotEmpty) {
      final List<dynamic> bookingsJson = jsonDecode(bookingsString);
      return bookingsJson.map((json) => ConfirmedBooking.fromJson(json)).toList();
    }
    return [];
  }

  // Cancel a booking by updating its status
  static Future<void> cancelBooking(String bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookings = await loadBookings();
    final index = bookings.indexWhere((b) => b.id == bookingId);

    if (index != -1) {
      bookings[index] = bookings[index].copyWith(status: 'Cancelled');
      await _saveBookingsToPrefs(prefs, bookings);
    }
  }

  // Helper to save the list of bookings to shared preferences
  static Future<void> _saveBookingsToPrefs(SharedPreferences prefs, List<ConfirmedBooking> bookings) async {
    final String bookingsString = jsonEncode(bookings.map((b) => b.toJson()).toList());
    await prefs.setString(_bookingKey, bookingsString);
  }
}
