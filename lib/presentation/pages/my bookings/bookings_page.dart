// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Bookings')),
        body: const Center(child: Text('Please log in to view bookings')),
      );
    }

    // Streams for different booking types
    final Stream<QuerySnapshot> diningRoomBookings =
        FirebaseFirestore.instance
            .collection('bookings')
            .where('userEmail', isEqualTo: user.email)
            .snapshots();

    final Stream<QuerySnapshot> packageBookings =
        FirebaseFirestore.instance
            .collection('package_bookings')
            .where('userEmail', isEqualTo: user.email)
            .snapshots();

    // Combine both streams
    final Stream<List<QuerySnapshot>> combinedStream = Rx.combineLatest2(
      diningRoomBookings,
      packageBookings,
      (QuerySnapshot a, QuerySnapshot b) => [a, b],
    );

    return Scaffold(
      backgroundColor: Colors.white, // Subtle background color
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: Text(
          'My Bookings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<List<QuerySnapshot>>(
        stream: combinedStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          // Extract and merge documents
          List<DocumentSnapshot> allBookings = [];
          allBookings.addAll(snapshot.data![0].docs); // Dining/Room bookings
          allBookings.addAll(snapshot.data![1].docs); // Package bookings

          // Sort by booking date (newest first)
          allBookings.sort((a, b) {
            DateTime aDate = _getBookingDate(a);
            DateTime bDate = _getBookingDate(b);
            return bDate.compareTo(aDate);
          });

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: allBookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final booking = allBookings[index].data() as Map<String, dynamic>;
              final bookingId = allBookings[index].id;
              final collection = _getBookingCollection(booking);

              if (booking.containsKey('restaurantName')) {
                return _buildDiningBooking(
                  context,
                  booking,
                  bookingId,
                  collection,
                );
              } else if (booking.containsKey('roomName')) {
                return _buildRoomBooking(
                  context,
                  booking,
                  bookingId,
                  collection,
                );
              } else if (booking.containsKey('packageTitle')) {
                return _buildPackageBooking(
                  context,
                  booking,
                  bookingId,
                  collection,
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  String _getBookingCollection(Map<String, dynamic> booking) {
    if (booking.containsKey('restaurantName') ||
        booking.containsKey('roomName')) {
      return 'bookings';
    } else if (booking.containsKey('packageTitle')) {
      return 'package_bookings';
    }
    return 'unknown';
  }

  Widget _buildDiningBooking(
    BuildContext context,
    Map<String, dynamic> booking,
    String bookingId,
    String collection,
  ) {
    final date = (booking['date'] as Timestamp).toDate();

    return BookingCard(
      icon: Icons.restaurant,
      title: booking['restaurantName'],
      subtitle: '${DateFormat('MMM d, y').format(date)} at ${booking['time']}',
      guests: booking['guestCount'],
      price: booking['totalAmount'],
      bookingId: bookingId,
      collection: collection,
      bookingType: 'dining',
      onCancel: () => _cancelBooking(context, bookingId, collection),
    );
  }

  Widget _buildRoomBooking(
    BuildContext context,
    Map<String, dynamic> booking,
    String bookingId,
    String collection,
  ) {
    final checkIn = DateTime.parse(booking['checkIn']);
    final checkOut = DateTime.parse(booking['checkOut']);

    return BookingCard(
      icon: Icons.hotel,
      title: booking['roomName'],
      subtitle:
          '${DateFormat('MMM d').format(checkIn)} - '
          '${DateFormat('MMM d, y').format(checkOut)}',
      guests: booking['guests'],
      price: booking['amount'],
      bookingId: bookingId,
      collection: collection,
      bookingType: 'room',
      onCancel: () => _cancelBooking(context, bookingId, collection),
    );
  }

  Widget _buildPackageBooking(
    BuildContext context,
    Map<String, dynamic> booking,
    String bookingId,
    String collection,
  ) {
    final checkIn = (booking['checkInDate'] as Timestamp).toDate();
    final checkOut = (booking['checkOutDate'] as Timestamp).toDate();

    return BookingCard(
      icon: Icons.luggage,
      title: booking['packageTitle'],
      subtitle:
          '${DateFormat('MMM d').format(checkIn)} - '
          '${DateFormat('MMM d, y').format(checkOut)} • ${booking['nights']} nights',
      guests: booking['guestCount'],
      price: booking['totalAmount'],
      bookingId: bookingId,
      collection: collection,
      bookingType: 'package',
      onCancel: () => _cancelBooking(context, bookingId, collection),
    );
  }

  DateTime _getBookingDate(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    if (data.containsKey('date')) {
      return (data['date'] as Timestamp).toDate();
    } else if (data.containsKey('checkInDate')) {
      return (data['checkInDate'] as Timestamp).toDate();
    } else if (data.containsKey('checkIn')) {
      return DateTime.parse(data['checkIn']);
    }
    return DateTime.now();
  }

  // Method to cancel a booking
  Future<void> _cancelBooking(
    BuildContext context,
    String bookingId,
    String collection,
  ) async {
    final theme = Theme.of(context);

    // Show confirmation dialog
    bool confirmCancel =
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cancel Booking'),
              content: const Text(
                'Are you sure you want to cancel this booking? This action cannot be undone and your payment will be refunded as per the cancellation policy please contact customer support for more details.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'No',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmCancel) return;

    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cancelling booking...'),
          duration: Duration(seconds: 1),
        ),
      );

      // Delete the booking from Firestore
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(bookingId)
          .delete();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking cancelled successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to cancel booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.hotel_outlined, size: 100, color: Colors.grey),
          const SizedBox(height: 24),
          const Text(
            'No Bookings Yet!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Looks like you haven\'t made any bookings yet. Start exploring and plan your perfect stay!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int guests;
  final dynamic price;
  final String bookingId;
  final String collection;
  final String bookingType;
  final VoidCallback onCancel;

  const BookingCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.guests,
    required this.price,
    required this.bookingId,
    required this.collection,
    required this.bookingType,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canCancel = _canCancelBooking();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 22, color: theme.primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                _buildBookingStatus(),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Details row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Guests info
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      '$guests ${guests == 1 ? 'Guest' : 'Guests'}',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ],
                ),

                // Price
                Row(
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      size: 16,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${price.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Cancel button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: canCancel ? onCancel : null,
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  backgroundColor: theme.colorScheme.error.withOpacity(0.1),
                  disabledForegroundColor: Colors.grey,
                  disabledBackgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  'Cancel Booking',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canCancelBooking() {
    // Implementation logic for checking if booking can be cancelled
    return true; // Default to allowing cancellations
  }

  Widget _buildBookingStatus() {
    // Determine booking status
    String status = "Confirmed";
    Color statusColor = Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
