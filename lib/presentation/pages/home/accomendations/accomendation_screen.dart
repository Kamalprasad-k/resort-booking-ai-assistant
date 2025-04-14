// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../models/models.dart';
import '../../../widgets/room_booking_sheet.dart';

// Note: Assuming Room class is defined elsewhere in your project

class AccommodationsScreen extends StatefulWidget {
  final List<Room> rooms;

  const AccommodationsScreen({super.key, required this.rooms});

  @override
  State<AccommodationsScreen> createState() => _AccommodationsScreenState();
}

class _AccommodationsScreenState extends State<AccommodationsScreen> {
  // Map to track expanded state of each room card
  final Map<int, bool> _expandedMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Our Accommodations',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        // Removed filter action button as requested
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        itemCount: widget.rooms.length + 1, // +1 for header
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader(context);
          } else {
            final room = widget.rooms[index - 1];
            final roomIndex = index - 1;
            // Initialize expanded state if not already set
            _expandedMap[roomIndex] ??= false;

            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildRoomCard(context, room, roomIndex),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find Your Perfect Stay',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Explore our handpicked collection of premium accommodations',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRoomCard(BuildContext context, Room room, int roomIndex) {
    final isExpanded = _expandedMap[roomIndex] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Carousel
          _buildImageCarousel(context, room),

          // Room Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        room.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '₹${room.price}/night',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Amenities
                Row(
                  children: [
                    _buildAmenityBadge(
                      context,
                      Icons.person_outline,
                      '${room.capacity} Guests',
                    ),
                    _buildAmenityBadge(
                      context,
                      Icons.square_foot,
                      '${room.size} sq.ft',
                    ),
                    if (room.features.isNotEmpty)
                      _buildAmenityBadge(
                        context,
                        Icons.star_border,
                        '${room.features.length} Features',
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Description - Now shows full text instead of limiting to 2 lines
                Text(
                  room.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                  maxLines: isExpanded ? null : 2,
                  overflow:
                      isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),

                // Show more/less button
                TextButton(
                  onPressed: () {
                    setState(() {
                      _expandedMap[roomIndex] = !isExpanded;
                    });
                  },
                  child: Text(
                    isExpanded ? 'Show Less' : 'Show More',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Room Details Section (Only visible when expanded)
                if (isExpanded) _buildDetailedRoomInfo(context, room),

                const SizedBox(height: 16),

                // Book Button
                ElevatedButton(
                  onPressed: () => _showBookingBottomSheet(context, room),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // New widget for detailed room information
  Widget _buildDetailedRoomInfo(BuildContext context, Room room) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        const Text(
          'Room Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        // Room Features
        if (room.features.isNotEmpty) ...[
          const Text(
            'Features',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                room.features.map((feature) {
                  return Chip(
                    label: Text(feature),
                    backgroundColor: Colors.grey[100],
                    labelStyle: TextStyle(color: Colors.grey[800]),
                  );
                }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        // Room Policies
        const Text(
          'Room Policies',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        _buildPolicyItem(Icons.access_time, 'Check-in: 2:00 PM'),
        _buildPolicyItem(Icons.access_time, 'Check-out: 12:00 PM'),
        _buildPolicyItem(Icons.smoke_free, 'No Smoking'),
        _buildPolicyItem(
          Icons.cancel,
          'Free cancellation up to 24 hours before check-in',
        ),

        if (room.additionalInfo != null && room.additionalInfo!.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            room.additionalInfo!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPolicyItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityBadge(BuildContext context, IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(BuildContext context, Room room) {
    // Using a different controller approach to avoid potential CarouselSliderController issues
    final currentIndexNotifier = ValueNotifier<int>(0);

    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            enableInfiniteScroll: true,
            autoPlay: false,
            onPageChanged: (index, reason) {
              currentIndexNotifier.value = index;
            },
          ),
          items:
              room.imageUrls.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.error, color: Colors.red),
                            ),
                      ),
                    );
                  },
                );
              }).toList(),
        ),

        // Page Indicator
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<int>(
            valueListenable: currentIndexNotifier,
            builder: (context, value, child) {
              return Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: value,
                  count: room.imageUrls.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Theme.of(context).primaryColor,
                    dotColor: Colors.white.withOpacity(0.5),
                    spacing: 6,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showBookingBottomSheet(BuildContext context, Room room) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingBottomSheet(room: room),
    );
  }
}
