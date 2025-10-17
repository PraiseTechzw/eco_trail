import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../models/eco_location_model.dart';

class MapService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get eco locations within a radius
  static Future<List<EcoLocation>> getEcoLocationsNearby(
    LatLng center,
    double radiusKm,
  ) async {
    try {
      // For now, we'll get all locations and filter client-side
      // In production, you'd use GeoFirestore for efficient geo queries
      final snapshot = await _firestore
          .collection('eco_locations')
          .where('isVerified', isEqualTo: true)
          .get();

      final locations = snapshot.docs
          .map((doc) => EcoLocation.fromFirestore(doc))
          .where((location) {
            final distance = _calculateDistance(
              center.latitude,
              center.longitude,
              location.coordinates.latitude,
              location.coordinates.longitude,
            );
            return distance <= radiusKm;
          })
          .toList();

      return locations;
    } catch (e) {
      throw Exception('Failed to fetch eco locations: $e');
    }
  }

  // Get all eco locations
  static Stream<List<EcoLocation>> getEcoLocationsStream() {
    return _firestore
        .collection('eco_locations')
        .where('isVerified', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EcoLocation.fromFirestore(doc))
              .toList(),
        );
  }

  // Search eco locations by name or type
  static Future<List<EcoLocation>> searchEcoLocations(String query) async {
    try {
      final snapshot = await _firestore
          .collection('eco_locations')
          .where('isVerified', isEqualTo: true)
          .get();

      final allLocations = snapshot.docs
          .map((doc) => EcoLocation.fromFirestore(doc))
          .toList();

      if (query.isEmpty) return allLocations;

      return allLocations.where((location) {
        return location.name.toLowerCase().contains(query.toLowerCase()) ||
            location.type.toLowerCase().contains(query.toLowerCase()) ||
            location.sustainabilityFeatures.any(
              (feature) => feature.toLowerCase().contains(query.toLowerCase()),
            );
      }).toList();
    } catch (e) {
      throw Exception('Failed to search eco locations: $e');
    }
  }

  // Filter locations by type
  static Future<List<EcoLocation>> filterLocationsByType(String type) async {
    try {
      final snapshot = await _firestore
          .collection('eco_locations')
          .where('isVerified', isEqualTo: true)
          .where('type', isEqualTo: type)
          .get();

      return snapshot.docs
          .map((doc) => EcoLocation.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to filter locations: $e');
    }
  }

  // Filter locations by eco certification
  static Future<List<EcoLocation>> filterLocationsByCertification(
    String certification,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('eco_locations')
          .where('isVerified', isEqualTo: true)
          .where('ecoCertification', isEqualTo: certification)
          .get();

      return snapshot.docs
          .map((doc) => EcoLocation.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to filter by certification: $e');
    }
  }

  // Calculate distance between two points in kilometers
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }
}
