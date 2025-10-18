
import 'package:flutter/material.dart';
import 'package:flutter_app/models/booking_model.dart';

class BookingProvider with ChangeNotifier {
  final List<ConfirmedBooking> _bookings = [];

  List<ConfirmedBooking> get bookings => _bookings;

  void addBooking(ConfirmedBooking booking) {
    _bookings.add(booking);
    notifyListeners();
  }
}
