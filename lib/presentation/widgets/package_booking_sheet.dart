// ignore_for_file: deprecated_member_use
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../models/models.dart';

class PackageBooking extends StatefulWidget {
  final Map<String, String> packagePreview;
  final PackageDetails packageDetails;

  const PackageBooking({
    Key? key,
    required this.packagePreview,
    required this.packageDetails,
  }) : super(key: key);

  @override
  State<PackageBooking> createState() => _PackageBookingSateState();
}

class _PackageBookingSateState extends State<PackageBooking> {
  late DateTime checkInDate;
  late DateTime checkOutDate;
  int guestCount = 1;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    checkInDate = DateTime.now().add(const Duration(days: 1));
    checkOutDate = checkInDate.add(const Duration(days: 3));
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPackageInfo(),
                  const SizedBox(height: 20),
                  _buildDateSelection(),
                  const SizedBox(height: 20),
                  _buildGuestSelection(),
                  const SizedBox(height: 20),
                  _buildPriceSummary(),
                  const SizedBox(height: 24),
                  _buildConfirmButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Book ${widget.packagePreview['title']}',
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPackageInfo() {
    final packagePrice = int.parse(
      widget.packageDetails.price.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: widget.packagePreview['image']!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.packagePreview['title']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'For: ${widget.packageDetails.targetAudience}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                '₹$packagePrice for 3 nights (min)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Dates',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _dateTile(
                label: 'Check‑in',
                date: checkInDate,
                onTap: () => _pickDate(isCheckIn: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _dateTile(
                label: 'Check‑out',
                date: checkOutDate,
                onTap: () => _pickDate(isCheckIn: false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Total: ${_calculateNights()} nights (min 3)',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _dateTile({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy').format(date),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of Guests',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$guestCount Guest${guestCount > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _guestBtn(Icons.remove, () {
                    if (guestCount > 1) setState(() => guestCount--);
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('$guestCount'),
                  ),
                  _guestBtn(Icons.add, () => setState(() => guestCount++)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _guestBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _buildPriceSummary() {
    final nights = _calculateNights();
    final basePrice = int.parse(
      widget.packageDetails.price.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    final perNight = (basePrice / 3).round();
    final extraNights = (nights > 3) ? nights - 3 : 0;
    final extraCost = extraNights * perNight;
    final roomTotal = basePrice + extraCost;
    final tax = (roomTotal * 0.18).round();
    final total = roomTotal + tax;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Summary',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _priceRow('Package Price (3 nights)', '₹$basePrice'),
          if (extraNights > 0)
            _priceRow(
              'Extra nights ($extraNights × ₹$perNight)',
              '₹$extraCost',
            ),
          const Divider(height: 24),
          _priceRow('Subtotal', '₹$roomTotal'),
          _priceRow('Taxes & Fees (18%)', '₹$tax'),
          const Divider(height: 24),
          _priceRow('Total Amount', '₹$total', isBold: true),
          const SizedBox(height: 8),
          Text(
            'Breakdown: 3‑night package + extra nights × per‑night rate + 18% tax',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      onPressed: _confirmBooking,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Confirm Booking',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _confirmBooking() async {
    final nights = _calculateNights();
    final basePrice = int.parse(
      widget.packageDetails.price.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    final perNight = (basePrice / 3).round();
    final extraNights = (nights > 3) ? nights - 3 : 0;
    final extraCost = extraNights * perNight;
    final roomTotal = basePrice + extraCost;
    final tax = (roomTotal * 0.18).round();
    final total = roomTotal + tax;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirm Booking'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.packagePreview['title']} for $nights nights'),
                Text('Check‑in: ${_fmt(checkInDate)}'),
                Text('Check‑out: ${_fmt(checkOutDate)}'),
                Text('Guests: $guestCount'),
                const SizedBox(height: 8),
                Text(
                  'Total: ₹$total',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  _initiatePayment(total);
                },
                child: const Text('Ok'),
              ),
            ],
          ),
    );
  }

  void _initiatePayment(int total) {
    if (FirebaseAuth.instance.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to book'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int amountInPaise = (total * 100).toInt();

    var options = {
      'key': 'rzp_test_2cFSPaT6A0UtKs', //Razorpay test key
      'amount': amountInPaise,
      'name': 'Package Booking',
      'description': 'Booking for ${widget.packagePreview['title']}',
      'prefill': {'email': FirebaseAuth.instance.currentUser!.email},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error initiating payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error initiating payment'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int nights = _calculateNights();
    final basePrice = int.parse(
      widget.packageDetails.price.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    final perNight = (basePrice / 3).round();
    final extraNights = (nights > 3) ? nights - 3 : 0;
    final extraCost = extraNights * perNight;
    final roomTotal = basePrice + extraCost;
    final tax = (roomTotal * 0.18).round();
    final total = roomTotal + tax;

    Map<String, dynamic> bookingData = {
      'packageId': widget.packageDetails.id, // Assumes PackageDetails has an id
      'packageTitle': widget.packagePreview['title'],
      'checkInDate': Timestamp.fromDate(checkInDate),
      'checkOutDate': Timestamp.fromDate(checkOutDate),
      'nights': nights,
      'guestCount': guestCount,
      'totalAmount': total,
      'userEmail': userEmail,
      'paymentId': response.paymentId,
      'status': 'booked',
      'bookingDate': Timestamp.now(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('package_bookings')
          .add(bookingData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking successful'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Close bottom sheet
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to store booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed: ${response.message}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Optional: Handle external wallet usage if needed
  }

  String _fmt(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

  Future<void> _pickDate({required bool isCheckIn}) async {
    final initial = isCheckIn ? checkInDate : checkOutDate;
    final first =
        isCheckIn ? DateTime.now() : checkInDate.add(const Duration(days: 3));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;

    setState(() {
      if (isCheckIn) {
        checkInDate = picked;
        checkOutDate = checkInDate.add(const Duration(days: 3));
      } else {
        checkOutDate = picked;
      }
    });
  }

  int _calculateNights() => checkOutDate.difference(checkInDate).inDays;
}
