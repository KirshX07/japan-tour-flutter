import 'dart:convert';
import 'package:flutter_app/models/booking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingHistoryService {
  static const _bookingHistoryKey = 'booking_history';

  /// Loads the list of confirmed bookings from local storage.
  static Future<List<ConfirmedBooking>> loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookingsString = prefs.getString(_bookingHistoryKey);

    if (bookingsString == null) {
      return [];
    }

    final List<dynamic> bookingJson = jsonDecode(bookingsString);
    return bookingJson
        .map((json) => ConfirmedBooking.fromJson(json))
        .toList()
        .reversed // Show most recent first
        .toList();
  }

  /// Saves a new booking to the existing list in local storage.
  static Future<void> saveBooking(ConfirmedBooking newBooking) async {
    final prefs = await SharedPreferences.getInstance();
    // Load existing bookings
    final String? bookingsString = prefs.getString(_bookingHistoryKey);
    List<dynamic> bookingList = bookingsString == null ? [] : jsonDecode(bookingsString);

    // Add the new booking
    bookingList.add(newBooking.toJson());

    // Save the updated list
    await prefs.setString(_bookingHistoryKey, jsonEncode(bookingList));
  }

  /// Cancels a booking by updating its status.
  static Future<void> cancelBooking(String bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookingsString = prefs.getString(_bookingHistoryKey);

    if (bookingsString == null) return;

    List<dynamic> bookingJsonList = jsonDecode(bookingsString);
    var bookingList = bookingJsonList.map((json) => ConfirmedBooking.fromJson(json)).toList();

    int index = bookingList.indexWhere((booking) => booking.id == bookingId);
    if (index != -1) {
      bookingList[index] = bookingList[index].copyWith(status: 'Cancelled');

      await prefs.setString(_bookingHistoryKey, jsonEncode(bookingList.map((b) => b.toJson()).toList()));
    }
  }
}