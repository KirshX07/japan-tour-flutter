import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/booking_model.dart';
import 'package:flutter_app/services/booking_service.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final String category;
  final String item;
  final int quantity;
  final double price;
  final DateTime date;
  final TimeOfDay time;

  const PaymentPage({
    super.key,
    required this.category,
    required this.item,
    required this.quantity,
    required this.price,
    required this.date,
    required this.time,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;
  final _formKey = GlobalKey<FormState>();

  // Controllers for the credit card form fields
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  final _paymentMethods = ['Credit Card', 'E-Wallet', 'Bank Transfer'];

  void _processPayment() {
    // Validate the credit card form if that method is selected
    if (_selectedPaymentMethod == 'Credit Card') {
      if (!_formKey.currentState!.validate()) {
        return; // If form is not valid, do not proceed
      }
    }

    // General validation for payment method selection
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Simulate payment processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Future.delayed(const Duration(seconds: 2), () {
      // Create a ConfirmedBooking object
      final newBooking = ConfirmedBooking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: widget.category,
        item: widget.item,
        quantity: widget.quantity,
        price: widget.price,
        date: widget.date,
        time: widget.time,
        status: 'Paid',
      );
      Navigator.of(context).pop(); // Close loading indicator
      BookingHistoryService.saveBooking(newBooking); // Save the booking
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment Successful! Your booking is confirmed.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      // Pop back to the home page after successful payment
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.price * widget.quantity;

    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      appBar: AppBar(
        title: const Text('Confirm & Pay', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionTitle('Order Summary'),
            _buildSummaryCard(total),
            const SizedBox(height: 24),
            _buildSectionTitle('Payment Method'),
            _buildPaymentOptions(),
            if (_selectedPaymentMethod == 'Credit Card') ...[
              const SizedBox(height: 24),
              _buildSectionTitle('Card Details'),
              _buildCreditCardForm(),
            ],
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Pay Now - \$${total.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
    );
  }

  Widget _buildSummaryCard(double total) {
    return Card(
      color: const Color(0xFF4A148C).withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.category}: ${widget.item}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            const Divider(color: Colors.white24, height: 20),
            _summaryRow('Date:', DateFormat.yMMMd().format(widget.date)),
            _summaryRow('Time:', widget.time.format(context)),
            _summaryRow('Quantity:', widget.quantity.toString()),
            _summaryRow('Price/Item:', '\$${widget.price.toStringAsFixed(2)}'),
            const Divider(color: Colors.white24, height: 20),
            _summaryRow('Total:', '\$${total.toStringAsFixed(2)}', isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 15)),
          Text(value, style: TextStyle(color: Colors.white, fontSize: isTotal ? 20 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      children: _paymentMethods.map((method) => RadioListTile<String>(
        title: Text(method, style: const TextStyle(color: Colors.white)),
        value: method,
        groupValue: _selectedPaymentMethod,
        onChanged: (value) => setState(() => _selectedPaymentMethod = value),
        activeColor: Colors.tealAccent,
        tileColor: Colors.white10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        controlAffinity: ListTileControlAffinity.trailing,
      )).toList(),
    );
  }

  Widget _buildCreditCardForm() {
    return Column(
      children: [
        TextFormField(
          controller: _cardNumberController,
          decoration: _inputDecoration('Card Number', '0000 0000 0000 0000'),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            _CardNumberInputFormatter(),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a card number';
            }
            if (value.replaceAll(' ', '').length != 16) {
              return 'Card number must be 16 digits';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryDateController,
                decoration: _inputDecoration('Expiry Date', 'MM/YY'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _CardExpiryInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter expiry date';
                  }
                  if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
                    return 'Invalid format (MM/YY)';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                decoration: _inputDecoration('CVV', '123'),
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter CVV';
                  }
                  if (value.length != 3) {
                    return 'CVV must be 3 digits';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white30),
      filled: true,
      fillColor: Colors.black.withOpacity(0.2),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.tealAccent)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.redAccent)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
    );
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class _CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}