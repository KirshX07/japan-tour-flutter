// lib/pages/schedule_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/models/planner_item_model.dart';
import 'package:flutter_app/providers/planner_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Pastikan sudah ditambahkan di pubspec.yaml
import '../copyright_footer.dart';
import '../widgets/page_header.dart';
import '../widgets/shared_widgets.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(title: "Planner", showBack: false),
        Expanded(
          child: SafeArea(
            top: false,
            child: Consumer<PlannerProvider>(
              builder: (context, plannerProvider, child) {
                final itemsByDate = plannerProvider.itemsByDate;

                if (itemsByDate.isEmpty) {
                  return _buildEmptyState();
                }

                final dates = itemsByDate.keys.toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    final date = dates[index];
                    final items = itemsByDate[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 8.0),
                          child: Text(
                            DateFormat.yMMMMd()
                                .format(date), // ex: October 8, 2025
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                        ...items.asMap().entries.map((entry) {
                          return AnimatedListItem(
                              index: entry.key,
                              child: _buildPlannerItemCard(context, entry.value, plannerProvider));
                        }),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 80, color: Colors.white38),
            SizedBox(height: 16),
            Text(
              'Your planner is empty.',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            SizedBox(height: 8),
            Text(
              'Add items from other pages to plan your trip.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlannerItemCard(
      BuildContext context, PlannerItem item, PlannerProvider provider) {
    return Card(
      color: const Color(0xFF4A148C).withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
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
        title: Text(
          item.place.name,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        subtitle: Text(
          item.place.description,
          maxLines: 1,
          style: const TextStyle(color: Colors.white70),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon:
                  const Icon(Icons.edit_calendar_outlined, color: Colors.lightBlueAccent),
              tooltip: 'Change date',
              onPressed: () => _showEditDatePicker(context, item, provider),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: 'Remove from planner',
              onPressed: () {
                provider.removeItem(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('${item.place.name} removed from your planner.'),
                    backgroundColor: Colors.red.shade400,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDatePicker(
      BuildContext context, PlannerItem item, PlannerProvider provider) async {
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
          content: Text(
              '${item.place.name} date updated to ${DateFormat.yMMMMd().format(pickedDate)}!'),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
