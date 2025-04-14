// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_managment/presentation/pages/home/dinnings/dinning_pages.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../Data/data.dart';
import '../../../models/models.dart';
import '../../widgets/home_widgets.dart';
import 'accomendations/accomendation_screen.dart';

class HotelInfoScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelInfoScreen({super.key, required this.hotel});

  @override
  State<HotelInfoScreen> createState() => _HotelInfoScreenState();
}

class _HotelInfoScreenState extends State<HotelInfoScreen> {
  final PageController _roomsPageController = PageController();
  final PageController _packagePageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _amenitiesScrollController = ScrollController();
  final PageController _pageController = PageController(viewportFraction: 0.85);
  late PageController _eventsPageController;
  Timer? _autoScrollTimer;
  bool _isScrolledDown = false;
  late Timer _timer;
  late PageController _diningPageController;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _eventsPageController = PageController(viewportFraction: 0.85);
    _diningPageController = PageController(viewportFraction: 0.85);
    // Auto-scroll setup
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_diningPageController.hasClients) {
        int nextPage =
            (_diningPageController.page!.round() + 1) %
            3; // Loop through 3 items
        _diningPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    // Add scroll listener to detect when user scrolls down
    _scrollController.addListener(_onScroll);

    // Auto-scroll amenities
    _startAmenitiesScrolling();
  }

  void _startAmenitiesScrolling() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_amenitiesScrollController.hasClients) {
        final double maxScrollExtent =
            _amenitiesScrollController.position.maxScrollExtent;
        const Duration scrollDuration = Duration(
          minutes: 1,
        ); // Adjust this duration

        // Start the infinite scroll loop
        _infiniteScrollLoop(maxScrollExtent, scrollDuration);
      } else {
        // Retry if controller isn't ready
        _startAmenitiesScrolling();
      }
    });
  }

  void _infiniteScrollLoop(double maxScrollExtent, Duration scrollDuration) {
    if (!_amenitiesScrollController.hasClients) return;

    final double currentPosition = _amenitiesScrollController.position.pixels;
    final double remainingDistance = maxScrollExtent - currentPosition;

    // Calculate duration proportionally for remaining distance
    final Duration adjustedDuration = Duration(
      milliseconds:
          (scrollDuration.inMilliseconds * remainingDistance / maxScrollExtent)
              .round(),
    );

    _amenitiesScrollController
        .animateTo(
          maxScrollExtent,
          duration: adjustedDuration,
          curve: Curves.linear,
        )
        .then((_) {
          if (_amenitiesScrollController.hasClients) {
            // Jump back to start and restart the loop
            _amenitiesScrollController.jumpTo(0);
            _infiniteScrollLoop(maxScrollExtent, scrollDuration);
          }
        });
  }

  void _onScroll() {
    final isScrolledDown = _scrollController.offset > 50;
    if (isScrolledDown != _isScrolledDown) {
      setState(() {
        _isScrolledDown = isScrolledDown;
      });
    }
  }

  @override
  void dispose() {
    _roomsPageController.dispose();
    _packagePageController.dispose();
    _scrollController.dispose();
    _amenitiesScrollController.dispose();
    _stopAutoScroll();
    _pageController.dispose();
    _diningPageController.dispose(); // Dispose new controller
    _eventsPageController.dispose();
    _timer.cancel(); // Cancel timer
    super.dispose();
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  bool _isExpanded = false;
  final int _maxLines = 3; // Number of lines to show when collapsed

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar with Hotel Image Carousel and Hotel Name
          SliverAppBar(
            surfaceTintColor: Colors.white,
            expandedHeight: screenHeight * 0.35, // Slightly reduced height
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Single Static Image (No Carousel)
                  Hero(
                    tag: 'hotel_image_${widget.hotel.id}_0', // Use first image
                    child: CachedNetworkImage(
                      imageUrl:
                          widget.hotel.imageUrls.isNotEmpty
                              ? widget.hotel.imageUrls[0] // Use the first image
                              : 'https://via.placeholder.com/400', // Fallback if no images
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: SizedBox(
                                width:
                                    24, // Smaller size for the loading indicator
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth:
                                      2, // Thinner stroke for a cleaner look
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey[400]!, // Subtle color
                                  ),
                                ),
                              ),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            color: Colors.grey[100],
                            child: const Icon(
                              Icons.error,
                              color: Colors.grey,
                              size: 40, // Reasonable size for error icon
                            ),
                          ),
                    ),
                  ),
                  // Gradient overlay for better text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  // Hotel Info Container
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel Name
                        Text(
                          widget.hotel.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 2),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Location
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Shevaroys, Tamil Nadu',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Rating and Reviews
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.hotel.rating} (${widget.hotel.reviews} reviews)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            title:
                _isScrolledDown
                    ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.hotel.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                widget.hotel.rating.toString(),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    : null,
          ),
          // Main Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel Info Card
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionHeader('Welcome to ${widget.hotel.name}'),
                      const SizedBox(height: 12),
                      // Description with Show More/Show Less
                      AnimatedCrossFade(
                        firstChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.hotel.description,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: Colors.grey[800],
                              ),
                              maxLines: _maxLines,
                              overflow: TextOverflow.ellipsis,
                            ),

                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isExpanded = true;
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                              ),
                              child: Text(
                                'Show More',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        secondChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.hotel.description,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: Colors.grey[800],
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isExpanded = false;
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                              ),
                              child: Text(
                                'Show Less',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        crossFadeState:
                            _isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),

                      // Price & Booking Section
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        margin: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Starting price',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '₹${widget.hotel.price}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '/ night',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => AccommodationsScreen(
                                              rooms: widget.hotel.rooms,
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Book Now',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Horizontal scrolling amenities
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 12),
                        child: buildSectionHeader('Amenities We Offer'),
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          controller: _amenitiesScrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              widget.hotel.amenities.length *
                              2, // Duplicate to create an infinite effect
                          itemBuilder: (context, index) {
                            final amenityName =
                                widget.hotel.amenities[index %
                                    widget.hotel.amenities.length];
                            final amenity = Amenity(
                              id: 'amenity_$index',
                              name: amenityName,
                              icon: getAmenityIcon(amenityName),
                            );
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: buildAmenityItem(context, amenity),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Our Accommodations Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionHeader('Our Accommodations'),
                      const SizedBox(height: 16),
                      // Featured Accommodation
                      _buildFeaturedAccommodation(context),
                      const SizedBox(height: 16),
                      // All Accommodations Button
                      buildViewAllButton(context, 'Book Now', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AccommodationsScreen(
                                  rooms: widget.hotel.rooms,
                                ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Rounded corners for the section
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionHeader('Dining Options'),
                      const SizedBox(
                        height: 12,
                      ), // Reduced slightly for tighter layout
                      SizedBox(
                        height:
                            340, // Increased slightly to fit enhanced card design
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            PageView.builder(
                              controller: _diningPageController,
                              itemCount:
                                  widget.hotel.diningOptions.take(3).length,
                              itemBuilder: (context, index) {
                                final dining =
                                    widget.hotel.diningOptions[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: buildEnhancedDiningCard(
                                    context,
                                    dining,
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 12, // Adjusted for better spacing
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SmoothPageIndicator(
                                  controller: _diningPageController,
                                  count:
                                      widget.hotel.diningOptions.take(3).length,
                                  effect: WormEffect(
                                    dotHeight: 10,
                                    dotWidth: 10,
                                    spacing: 8,
                                    activeDotColor:
                                        Theme.of(context).primaryColor,
                                    dotColor: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ), // Increased for better separation
                      Center(
                        child: buildViewAllButton(
                          context,
                          'Explore Dining Options',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DiningScreen(
                                      diningOptions: widget.hotel.diningOptions,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.grey[50]!],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionHeader('Events & Celebrations'),

                      const SizedBox(height: 16),
                      SizedBox(
                        height: 240, // Adjusted height for compact cards
                        child: ListView.builder(
                          controller: _eventsPageController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.hotel.events.length,
                          itemBuilder: (context, index) {
                            final event = widget.hotel.events[index];
                            return buildEventCard(context, event);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                buildResortSection('Our Packages', resortPackages),
                const SizedBox(height: 8),
                // Contact & Location Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionHeader('Contact & Location'),
                      const SizedBox(height: 16),
                      // Location Card with Dummy Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            // Dummy Map Image
                            Image.asset(
                              'assets/images/location.png',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            // Gradient overlay
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hotel Location',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.hotel.location,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton.icon(
                                      onPressed:
                                          () => launchUrll(
                                            'https://maps.app.goo.gl/mMsQHeeaTvrjBBNd6',
                                          ),
                                      icon: const Icon(
                                        Icons.directions,
                                        color: Colors.white,
                                      ),
                                      label: const Text('Get Directions'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Contact Information
                      buildContactInfoItem(
                        context,
                        Icons.phone,
                        'Phone',
                        '+91 7708370616',
                        () => launchUrll('tel:+917708370616'),
                      ),
                      const Divider(height: 24),
                      buildContactInfoItem(
                        context,
                        Icons.email,
                        'Email',
                        'reservations@hotel.com',
                        () => launchUrll('mailto:lingeshkumar756@gmail.com'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedAccommodation(BuildContext context) {
    if (widget.hotel.rooms.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => AccommodationsScreen(rooms: widget.hotel.rooms),
          ),
        );
      },
      child: SizedBox(
        height: 200, // Adjust height as needed
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.hotel.rooms.length,

          padEnds: false, // No padding at ends for better overlap effect
          itemBuilder: (context, index) {
            final room = widget.hotel.rooms[index];

            return Padding(
              padding: const EdgeInsets.only(right: 8.0), // Space between cards
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Room Image
                      CachedNetworkImage(
                        imageUrl: room.imageUrls.first,
                        height: 200,
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
                              child: const Icon(Icons.error),
                            ),
                      ),
                      // Gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                room.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.king_bed,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${room.capacity} Person(s)',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(
                                    Icons.aspect_ratio,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${room.size} sq.ft',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹${room.price} / night',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
