import 'package:flutter/material.dart';
import 'package:flutter_app/models/booking_model.dart';
import 'package:flutter_app/services/booking_service.dart';
import 'package:flutter_app/pages/payment_page.dart';
import 'package:intl/intl.dart';


class BookingCheckoutWidget extends StatefulWidget {
  final BookingCategory? initialCategory;
  final BookingItem? initialItem;

  const BookingCheckoutWidget({
    super.key,
    this.initialCategory,
    this.initialItem,
  });

  @override
  State<BookingCheckoutWidget> createState() => _BookingCheckoutWidgetState();
}

class _BookingCheckoutWidgetState extends State<BookingCheckoutWidget> {
  BookingCategory? _selectedCategory;
  BookingItem? _selectedItem;
  List<BookingItem> _itemsForCategory = [];

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _quantity = 1;
  double _pricePerItem = 0.0;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // If an initial item is passed, pre-populate the state.
    if (widget.initialCategory != null && widget.initialItem != null) {
      _selectedCategory = widget.initialCategory;
      _itemsForCategory = widget.initialCategory!.items;
      _selectedItem = widget.initialItem;
      _pricePerItem = widget.initialItem!.price;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _showConfirmation() {
    if (_formKey.currentState!.validate()) {
      // Add validation for date and time
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a date and time.'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
        return;
      }


      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2C195D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Confirm Booking', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category: ${_selectedCategory!.name}', style: const TextStyle(color: Colors.white70, fontFamily: 'Poppins')),
              const SizedBox(height: 8),
              Text('Item: ${_selectedItem!.name}', style: const TextStyle(color: Colors.white70, fontFamily: 'Poppins')),
              const SizedBox(height: 8),
              Text('Date: ${DateFormat.yMd().format(_selectedDate!)}', style: const TextStyle(color: Colors.white70, fontFamily: 'Poppins')),
              const SizedBox(height: 8),
              Text('Time: ${_selectedTime!.format(context)}', style: const TextStyle(color: Colors.white70, fontFamily: 'Poppins')),
              const SizedBox(height: 8),
              Text('Quantity: $_quantity', style: const TextStyle(color: Colors.white70, fontFamily: 'Poppins')),
              const SizedBox(height: 12),
              Text(
                'Total: \$${(_quantity * _pricePerItem).toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Poppins'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage(
                    category: _selectedCategory!.name,
                    item: _selectedItem!.name,
                    quantity: _quantity,
                    price: _pricePerItem,
                    date: _selectedDate!,
                    time: _selectedTime!,
                  )),
                ).then((_) => Navigator.of(context).pop()); // Close bottom sheet after payment page is closed
              },
              child: const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  void _showBookingResult() async {
    List<ConfirmedBooking> bookings = await BookingHistoryService.loadBookings();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2C195D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Booking History', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              content: SizedBox(
                width: double.maxFinite,
                child: bookings.isEmpty
                    ? const Text('You have not made any bookings yet.', style: TextStyle(color: Colors.white70, fontFamily: 'Poppins'))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          final total = booking.price * booking.quantity;
                          final isCancellable = booking.status == 'Paid';

                          return Card(
                            color: Colors.black.withOpacity(0.2),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${booking.category}: ${booking.item}',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const Divider(color: Colors.white24, height: 16),
                                  _buildHistoryRow('Date:', DateFormat.yMMMd().format(booking.date)),
                                  _buildHistoryRow('Quantity:', booking.quantity.toString()),
                                  _buildHistoryRow('Status:', booking.status, statusColor: booking.status == 'Paid' ? Colors.greenAccent : Colors.orangeAccent),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (isCancellable)
                                        TextButton(
                                          onPressed: () async {
                                            await BookingHistoryService.cancelBooking(booking.id);
                                            final updatedBookings = await BookingHistoryService.loadBookings();
                                            setState(() {
                                              bookings = updatedBookings;
                                            });
                                          },
                                          child: const Text('Cancel', style: TextStyle(color: Colors.redAccent)),
                                        ),
                                      const Spacer(),
                                      Text(
                                        'Total: \$${total.toStringAsFixed(2)}',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Widget _buildHistoryRow(String label, String value, {Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: TextStyle(
              color: statusColor ?? Colors.white,
              fontWeight: statusColor != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF4A148C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Center(
              child: Text(
                'Make a Reservation',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
            ),
            const SizedBox(height: 20),
            _buildCategorySelector(),
            const SizedBox(height: 16),
            if (_selectedCategory != null) _buildItemSelector(),
            if (_selectedCategory != null) const SizedBox(height: 16),
            _buildDateTimePicker(),
            const SizedBox(height: 16),
            _buildQuantitySelector(),
            const SizedBox(height: 24),
            _buildCheckoutSummary(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
              label: const Text('Proceed to Checkout', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins')),
              onPressed: _showConfirmation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.receipt_long_outlined, color: Colors.white70),
              label: const Text('Check Booking Result', style: TextStyle(color: Colors.white70, fontSize: 16, fontFamily: 'Poppins')),
              onPressed: _showBookingResult,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return DropdownButtonFormField<BookingCategory>(
      value: _selectedCategory,
      hint: const Text('Select a Category', style: TextStyle(color: Colors.white70)),
      dropdownColor: const Color(0xFF2C195D),
      style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      decoration: _inputDecoration('Category', Icons.category_outlined),
      items: bookingData.map((BookingCategory category) {
        return DropdownMenuItem<BookingCategory>(
          // Disable other categories if one is pre-selected
          value: category,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: widget.initialCategory != null
          ? null
          : (newValue) {
              setState(() {
                _selectedCategory = newValue;
                _selectedItem = null; // Reset item
                _pricePerItem = 0.0; // Reset price
                if (newValue != null) {
                  _itemsForCategory = newValue.items;
                } else {
                  _itemsForCategory = [];
                }
              });
            },
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

  Widget _buildItemSelector() {
    return DropdownButtonFormField<BookingItem>(
      value: _selectedItem,
      hint: const Text('Select an Item', style: TextStyle(color: Colors.white70)),
      dropdownColor: const Color(0xFF2C195D),
      style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      decoration: _inputDecoration('Item', Icons.shopping_bag_outlined),
      items: _itemsForCategory.map((BookingItem item) {
        return DropdownMenuItem<BookingItem>(
          value: item,
          child: Text('${item.name} - \$${item.price.toStringAsFixed(2)}'),
        );
      }).toList(),
      onChanged: widget.initialItem != null
          ? null
          : (newValue) {
              setState(() {
                _selectedItem = newValue;
                if (newValue != null) {
                  _pricePerItem = newValue.price;
                } else {
                  _pricePerItem = 0.0;
                }
              });
            },
      validator: (value) => value == null ? 'Please select an item' : null,
    );
  }

  Widget _buildDateTimePicker() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: _inputDecoration('Date', Icons.calendar_today_outlined),
              child: Text(
                _selectedDate == null ? 'Select Date' : DateFormat.yMd().format(_selectedDate!),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: () => _selectTime(context),
            child: InputDecorator(
              decoration: _inputDecoration('Time', Icons.access_time_outlined),
              child: Text(
                _selectedTime == null ? 'Select Time' : _selectedTime!.format(context),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return InputDecorator(
      decoration: _inputDecoration('Quantity', Icons.people_outline),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.white70), onPressed: () => setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1)),
          Text('$_quantity', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.white70), onPressed: () => setState(() => _quantity++)),
        ],
      ),
    );
  }

  Widget _buildCheckoutSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total Price', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins')),
          Text(
            '\$${(_quantity * _pricePerItem).toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurpleAccent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}