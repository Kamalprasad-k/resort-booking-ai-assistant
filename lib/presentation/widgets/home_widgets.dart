// ignore_for_file: deprecated_member_use
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hotel_managment/Data/data.dart';
import 'package:hotel_managment/presentation/pages/home/dinnings/dinning_pages.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;
import '../../models/models.dart';
import '../pages/home/events/events_details_page.dart';
import '../pages/home/packages/packages_screen.dart';

Widget buildViewAllButton(
  BuildContext context,
  String label,
  VoidCallback onTap,
) {
  return SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).primaryColor),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget buildAmenityItem(BuildContext context, Amenity amenity) {
  return Container(
    width: 120,

    margin: const EdgeInsets.only(right: 12),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    decoration: BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor, width: 1),
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getAmenityIcon(amenity.name),
        const SizedBox(height: 6),
        Text(
          amenity.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

Widget getAmenityIcon(String amenityName) {
  const double iconSize = 24.0;

  switch (amenityName) {
    case 'Swimming Pool':
      return Image.asset(
        'assets/icons/pool.png',
        width: iconSize,
        height: iconSize,
      );
    case 'Restaurant':
    case 'Multi-Cuisine Restaurant':
      return Image.asset(
        'assets/icons/restaurant.png',
        width: iconSize,
        height: iconSize,
      );
    case 'Spa':
      return Image.asset(
        'assets/icons/massage.png', // fallback or create a spa.png
        width: iconSize,
        height: iconSize,
      );
    case 'Fitness Center':
      return Image.asset(
        'assets/icons/activities.png',
        width: iconSize,
        height: iconSize,
      );
    case 'Free Wi-Fi':
      return Image.asset(
        'assets/icons/wifi.png',
        width: iconSize,
        height: iconSize,
      );
    case 'Parking':
      return Image.asset(
        'assets/icons/parking.png',
        width: iconSize,
        height: iconSize,
      );
    case 'Room Service':
      return Image.asset(
        'assets/icons/room_service.png',
        width: iconSize,
        height: iconSize,
      );
    case 'Conference Hall':
      return Image.asset(
        'assets/icons/conference.png',
        width: iconSize,
        height: iconSize,
      );
    case 'Garden':
      return Image.asset(
        'assets/icons/garden.png',
        width: iconSize,
        height: iconSize,
      );
    case 'Bonfire':
      return Image.asset(
        'assets/icons/bonefire.png', // fallback or create a bonfire.png
        width: iconSize,
        height: iconSize,
      );
    case 'Indoor Games':
      return Image.asset(
        'assets/icons/games.png',
        width: iconSize,
        height: iconSize,
      );
    case 'Outdoor Activities':
      return Image.asset(
        'assets/icons/activities.png',
        width: iconSize,
        height: iconSize,
      );
    case 'Tour Packages':
      return Image.asset(
        'assets/icons/tour.png',
        width: iconSize,
        height: iconSize,
      );
    case 'Banquet Hall':
      return Image.asset(
        'assets/icons/city-hall.png', // fallback or create a banquet.png
        width: iconSize,
        height: iconSize,
      );
    default:
      return Image.asset(
        'assets/icons/amenities.png',
        width: iconSize,
        height: iconSize,
      );
  }
}

Widget buildEnhancedDiningCard(BuildContext context, DiningOption dining) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  DiningScreen(diningOptions: hotels.first.diningOptions),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Image
            CachedNetworkImage(
              imageUrl: dining.imageUrl,
              height: 340, // Increased to fill card
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.restaurant,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
            ),
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Text content
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dining.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 2)],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dining.cuisines.join(', '),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dining.openingHours,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildEventCard(BuildContext context, EventType event) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailsScreen(event: event),
        ),
      );
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 220, // Fixed width for compact cards
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with rounded top
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: event.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.event,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  event.shortDescription,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Accent Chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildHorizontalCard(BuildContext context, Map<String, String> item) {
  return Container(
    width: 160,
    margin: const EdgeInsets.only(right: 16),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PackageDetailsScreen(
                  packagePreview: item,
                  packageDetails: PackageDetails.fromPackageType(
                    item['title']!,
                  ),
                ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(imageUrl: item['image']!, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item['description']!,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildContactInfoItem(
  BuildContext context,
  IconData icon,
  String label,
  String value,
  VoidCallback onTap,
) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        ],
      ),
    ),
  );
}

Widget buildResortSection(String title, List<Map<String, String>> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: buildSectionHeader(title),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: items.length,
          itemBuilder:
              (context, index) => buildHorizontalCard(context, items[index]),
        ),
      ),
    ],
  );
}

Future<void> launchUrll(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $url');
  }
}

Widget buildSectionHeader(String title) {
  return Text(
    title,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );
}
