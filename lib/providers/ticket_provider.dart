
import 'package:flutter/material.dart';
import 'package:flutter_app/models/planner_item_model.dart';

class TicketProvider with ChangeNotifier {
  final List<PlannerItem> _tickets = [];

  List<PlannerItem> get tickets => _tickets;

  void addTicket(PlannerItem item) {
    _tickets.add(item);
    notifyListeners();
  }

  void removeTicket(PlannerItem item) {
    _tickets.remove(item);
    notifyListeners();
  }
}
