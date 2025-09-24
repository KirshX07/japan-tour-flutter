// lib/pages/schedule_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Add intl to pubspec.yaml
import '../copyright_footer.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  bool _animateBanner = false;

  @override
  void initState() {
    super.initState();
    // jalankan animasi setelah build
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _animateBanner = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
            height: _animateBanner ? 110 : 0,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(top: 40),
            child: const Center(
              child: Text(
                "Your Planner",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Consumer<PlannerProvider>(
              builder: (context, plannerProvider, child) {
                final itemsByDate = plannerProvider.itemsByDate;

                if (itemsByDate.isEmpty) {
                  return const Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 80, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Your planner is empty.',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              Text(
                                'Add items from other pages to plan your trip.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CopyrightFooter(),
                    ],
                  );
                }

                final dates = itemsByDate.keys.toList();

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: dates.length,
                        itemBuilder: (context, index) {
                          final date = dates[index];
                          final items = itemsByDate[date]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                                child: Text(
                                  DateFormat.yMMMMd().format(date), // e.g., July 10, 2024
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              ...items.map((item) => _buildPlannerItemCard(context, item, plannerProvider)),
                            ],
                          );
                        },
                      ),
                    ),
                    const CopyrightFooter(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlannerItemCard(BuildContext context, PlannerItem item, PlannerProvider provider) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            item.place.imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(item.place.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(item.place.description, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_calendar_outlined, color: Colors.blue),
              tooltip: 'Change date',
              onPressed: () => _showEditDatePicker(context, item, provider),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Remove from planner',
              onPressed: () {
                provider.removeItem(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDatePicker(BuildContext context, PlannerItem item, PlannerProvider provider) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: item.date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && pickedDate != item.date && context.mounted) {
      await provider.updateItemDate(item, pickedDate);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.place.name} date updated!'),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}