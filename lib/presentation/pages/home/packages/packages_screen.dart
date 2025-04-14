// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../models/models.dart';
import '../../../widgets/package_booking_sheet.dart';

class PackageDetailsScreen extends StatelessWidget {
  final Map<String, String> packagePreview;
  final PackageDetails packageDetails;

  const PackageDetailsScreen({
    super.key,
    required this.packagePreview,
    required this.packageDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 24),
                  _buildStayInfo(),
                  const SizedBox(height: 24),
                  _buildAdventuresSection(),
                  const SizedBox(height: 24),
                  _buildDiningSection(),
                  const SizedBox(height: 24),
                  _buildAddOnsSection(),
                  const SizedBox(height: 24),
                  _buildPriceAndBooking(context),
                  const SizedBox(height: 32),
                  _buildNotesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      expandedHeight: 250,
      pinned: true,
      leading: IconButton(
        color: Colors.white,
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: packagePreview['image']!,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Text(
                packagePreview['title']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'For: ${packageDetails.targetAudience}',
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              '4.8',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(124 reviews)',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          packagePreview['description']!,
          style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildStayInfo() {
    return _buildDetailSection(
      title: 'Stay',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            packageDetails.stay,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: _findRoomImage(packageDetails.stay),
            ),
          ),
        ],
      ),
    );
  }

  Widget _findRoomImage(String stayName) {
    // Find an appropriate room image based on the stay name
    if (stayName.contains('Honeymoon Haven')) {
      return CachedNetworkImage(
        imageUrl:
            'https://images.unsplash.com/photo-1668435528344-b70cedd6df88?q=80&w=1931&auto=format&fit=crop&ixlib=rb-4.0.3',
        fit: BoxFit.cover,
      );
    } else if (stayName.contains('Family Suite')) {
      return CachedNetworkImage(
        imageUrl:
            'https://images.unsplash.com/photo-1594130139005-3f0c0f0e7c5e?q=80&w=2012&auto=format&fit=crop&ixlib=rb-4.0.3',
        fit: BoxFit.cover,
      );
    } else if (stayName.contains('Azure Retreat')) {
      return CachedNetworkImage(
        imageUrl:
            'https://images.unsplash.com/photo-1662385930165-49ebaa03b152?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3',
        fit: BoxFit.cover,
      );
    } else {
      return CachedNetworkImage(
        imageUrl:
            'https://images.unsplash.com/photo-1630999295881-e00725e1de45?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3',
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildAdventuresSection() {
    return _buildDetailSection(
      title: 'Adventures',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            packageDetails.adventures.map((adventure) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        adventure,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildDiningSection() {
    return _buildDetailSection(
      title: 'Dining',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            packageDetails.dining.map((meal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.restaurant, color: Colors.amber, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        meal,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildAddOnsSection() {
    return _buildDetailSection(
      title: 'Add-Ons',
      content: Text(
        packageDetails.addOns,
        style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
      ),
    );
  }

  Widget _buildPriceAndBooking(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    packageDetails.price,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder:
                        (_) => PackageBooking(
                          packageDetails: packageDetails,
                          packagePreview: packagePreview,
                        ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
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
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildNoteItem('All packages include WiFi and resort access.'),
          _buildNoteItem(
            'Upgrades: Add butler service (₹150/day) or private chef.',
          ),
          _buildNoteItem('Minimum stay: 3 nights for packages.'),
        ],
      ),
    );
  }

  Widget _buildNoteItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.grey, size: 18),
          const SizedBox(width: 12),
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

  Widget _buildDetailSection({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }
}
