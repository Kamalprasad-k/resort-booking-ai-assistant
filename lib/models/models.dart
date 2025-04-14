import 'package:flutter/material.dart';

class Hotel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int reviews;
  final int price;
  final String description;
  final List<String> imageUrls;
  final List<Room> rooms;
  final List<String> amenities;
  final List<DiningOption> diningOptions;
  final List<Package> packages;
  final List<EventType> events;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.description,
    required this.imageUrls,
    required this.rooms,
    required this.amenities,
    required this.diningOptions,
    required this.packages,
    required this.events,
  });
}

class Room {
  final String id; // Added id field
  final String name;
  final int price; // Price per night in INR
  final int capacity;
  final int size; // Size in sq.m
  final List<String> imageUrls;
  final List<String> features;
  final String description;
  final String bestFor;
  final Map<String, dynamic> accommodationDetails;
  final Map<String, dynamic> bookingInformation;
  final List<String> specialFeatures;

  Room({
    required this.id,
    required this.name,
    required this.price,
    required this.capacity,
    required this.size,
    required this.imageUrls,
    required this.features,
    required this.description,
    required this.bestFor,
    required this.accommodationDetails,
    required this.bookingInformation,
    required this.specialFeatures,
  });
}

class DiningOption {
  final String id; // Added id field
  final String name;
  final List<String> cuisines;
  final String openingHours;
  final String imageUrl;
  final String description;
  final List<String> highlights;
  final double seatBookingPrice;

  DiningOption({
    required this.id,
    required this.seatBookingPrice,
    required this.name,
    required this.cuisines,
    required this.openingHours,
    required this.imageUrl,
    required this.description,
    this.highlights = const [],
  });
}

class Package {
  final String id; // Added id field
  final String name;
  final int price;
  final String description;
  final List<String> inclusions;

  Package({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.inclusions,
  });
}

class EventType {
  final String id; // Added id field
  final String name;
  final String shortDescription;
  final String description;
  final String capacity;
  final List<String> inclusions;
  final String imageUrl;

  EventType({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.capacity,
    required this.inclusions,
    required this.imageUrl,
  });
}

class Amenity {
  final String id;
  final String name;
  final Widget icon;

  Amenity({required this.id, required this.name, required this.icon});
}

class PackageDetails {
  final String id;
  final String targetAudience;
  final String stay;
  final List<String> adventures;
  final List<String> dining;
  final String addOns;
  final String price;

  PackageDetails({
    required this.id,
    required this.targetAudience,
    required this.stay,
    required this.adventures,
    required this.dining,
    required this.addOns,
    required this.price,
  });

  factory PackageDetails.fromPackageType(String packageType) {
    switch (packageType) {
      case 'Romantic Escape Package':
        return PackageDetails(
          id: '1',
          targetAudience: 'Couples & Honeymooners',
          stay: 'Honeymoon Haven (90 sq.m suite with private jacuzzi)',
          adventures: [
            'Glass Sky Walk (sunset timing)',
            'Private Floating Breakfast in pool',
            'Sunset cocktails at Emerald Villa',
          ],
          dining: [
            'Romantic Cave Dinner',
            'Chef\'s 7-course tasting menu at Coral Reef Restaurant',
          ],
          addOns: 'Couples\' massage, rose petal turndown.',
          price: '₹28,500/week',
        );
      case 'Thrill-Seeker\'s Adventure Package':
        return PackageDetails(
          id: '2',
          targetAudience: 'Adults & Adventure Enthusiasts',
          stay: 'Azure Retreat (overwater suite with ocean access)',
          adventures: [
            'High Rope Course + Waterfall Rappelling',
            'Roller Coaster Zipline + Jet Skiing',
            'ATV Ride (rugged terrain)',
          ],
          dining: [
            'BBQ feast at Sunset Grill',
            'Tapas & Misty Hills Cocktail at Breeze Sky Lounge',
          ],
          addOns: 'Complimentary snorkel gear, late checkout.',
          price: '₹32,000/week',
        );
      case 'Family Fun Package':
        return PackageDetails(
          id: '3',
          targetAudience: 'Families (up to 6 members)',
          stay: 'Family Suite (150 sq.m with bunk beds & play area)',
          adventures: [
            'Low Rope Course (kids) + Trampoline Park',
            'Banana Boat Ride + Kayaking',
            'Kids\' Dirt Bike Adventure',
          ],
          dining: [
            'Wood-fired pizza at Azure Lagoon Café',
            'Picnic Basket for hill explorations',
          ],
          addOns: 'Game console, baby cots, sea-view terrace.',
          price: '₹38,000/week',
        );
      case 'Budget Nature Retreat':
        return PackageDetails(
          id: '4x',
          targetAudience: 'Solo Travelers or Couples',
          stay: 'Garden Cottage (65 sq.m in tropical gardens)',
          adventures: [
            'Glass SkyWalk + Infinity Pool Swimming',
            'Guided Plantation Dining experience',
          ],
          dining: [
            'Spice Garden (herb-picking interactive meal)',
            'Complimentary coffee/tea pairing',
          ],
          addOns: 'Spa discount, communal beach access.',
          price: '₹15,000/week',
        );
      default:
        throw Exception('Unknown package type');
    }
  }
}
