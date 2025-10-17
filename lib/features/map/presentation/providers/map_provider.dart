import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/services/map_service.dart';
import '../../../../models/eco_location_model.dart';

// Map controller provider
final mapControllerProvider = StateProvider<GoogleMapController?>(
  (ref) => null,
);

// Current location provider
final currentLocationProvider = StateProvider<LatLng?>((ref) => null);

// Eco locations provider
final ecoLocationsProvider = StreamProvider<List<EcoLocation>>((ref) {
  return MapService.getEcoLocationsStream();
});

// Selected location provider
final selectedLocationProvider = StateProvider<EcoLocation?>((ref) => null);

// Map markers provider
final mapMarkersProvider = Provider<Set<Marker>>((ref) {
  final locations = ref.watch(ecoLocationsProvider);
  final selectedLocation = ref.watch(selectedLocationProvider);

  return locations.when(
    data: (locations) {
      final markers = <Marker>{};

      for (final location in locations) {
        final markerId = MarkerId(location.id);
        final isSelected = selectedLocation?.id == location.id;

        markers.add(
          Marker(
            markerId: markerId,
            position: LatLng(
              location.coordinates.latitude,
              location.coordinates.longitude,
            ),
            infoWindow: InfoWindow(
              title: location.name,
              snippet: location.type,
            ),
            icon: isSelected
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen,
                  )
                : _getMarkerIcon(location.type),
            onTap: () {
              ref.read(selectedLocationProvider.notifier).state = location;
            },
          ),
        );
      }

      return markers;
    },
    loading: () => <Marker>{},
    error: (_, __) => <Marker>{},
  );
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filter type provider
final filterTypeProvider = StateProvider<String?>((ref) => null);

// Filter certification provider
final filterCertificationProvider = StateProvider<String?>((ref) => null);

// Filtered locations provider
final filteredLocationsProvider = FutureProvider<List<EcoLocation>>((
  ref,
) async {
  final searchQuery = ref.watch(searchQueryProvider);
  final filterType = ref.watch(filterTypeProvider);
  final filterCertification = ref.watch(filterCertificationProvider);

  if (searchQuery.isNotEmpty) {
    return MapService.searchEcoLocations(searchQuery);
  } else if (filterType != null) {
    return MapService.filterLocationsByType(filterType);
  } else if (filterCertification != null) {
    return MapService.filterLocationsByCertification(filterCertification);
  } else {
    // Return all locations
    final locations = await MapService.getEcoLocationsNearby(
      const LatLng(37.7749, -122.4194), // Default to San Francisco
      50.0, // 50km radius
    );
    return locations;
  }
});

// Helper function to get marker icon based on location type
BitmapDescriptor _getMarkerIcon(String type) {
  switch (type.toLowerCase()) {
    case 'eco lodge':
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    case 'nature trail':
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    case 'cultural site':
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    case 'local farm':
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    case 'sustainable restaurant':
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    case 'green hotel':
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    case 'wildlife reserve':
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
    case 'organic market':
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
    default:
      return BitmapDescriptor.defaultMarker;
  }
}
