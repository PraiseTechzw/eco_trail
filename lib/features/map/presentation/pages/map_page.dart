import 'package:eco_trail/models/eco_location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/map_provider.dart';
import '../widgets/location_details_bottom_sheet.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final permission = await Permission.location.request();
    if (permission.isGranted) {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final location = LatLng(position.latitude, position.longitude);
        ref.read(currentLocationProvider.notifier).state = location;

        // Update map camera to current location
        final controller = ref.read(mapControllerProvider);
        if (controller != null) {
          controller.animateCamera(
            CameraUpdate.newLatLngZoom(location, AppConstants.defaultZoom),
          );
        }
      } catch (e) {
        debugPrint('Error getting location: $e');
      }
    }
  }

  void _showLocationDetails(EcoLocation location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationDetailsBottomSheet(location: location),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = ref.watch(currentLocationProvider);
    final markers = ref.watch(mapMarkersProvider);
    final selectedLocation = ref.watch(selectedLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    ref.read(mapControllerProvider.notifier).state = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: currentLocation,
                    zoom: AppConstants.defaultZoom,
                  ),
                  markers: markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  onTap: (LatLng position) {
                    // Clear selection when tapping on empty area
                    ref.read(selectedLocationProvider.notifier).state = null;
                  },
                ),
                if (selectedLocation != null)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.eco,
                          color: AppColors.primaryGreen,
                        ),
                        title: Text(selectedLocation.name),
                        subtitle: Text(selectedLocation.type),
                        trailing: IconButton(
                          icon: const Icon(Icons.info),
                          onPressed: () =>
                              _showLocationDetails(selectedLocation),
                        ),
                        onTap: () => _showLocationDetails(selectedLocation),
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "location",
            onPressed: _getCurrentLocation,
            backgroundColor: AppColors.primaryGreen,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "eco_locations",
            onPressed: () {
              _showEcoLocationsList();
            },
            backgroundColor: AppColors.secondaryGreen,
            child: const Icon(Icons.eco, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Eco Locations'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Search by name, type, or feature...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Search is handled by the provider
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Locations'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Types'),
              onTap: () {
                ref.read(filterTypeProvider.notifier).state = null;
                Navigator.pop(context);
              },
            ),
            ...AppConstants.locationTypes.map(
              (type) => ListTile(
                title: Text(type),
                onTap: () {
                  ref.read(filterTypeProvider.notifier).state = type;
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEcoLocationsList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Eco Locations',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final locationsAsync = ref.watch(ecoLocationsProvider);

                  return locationsAsync.when(
                    data: (locations) => ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        final location = locations[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.eco,
                              color: AppColors.primaryGreen,
                            ),
                            title: Text(location.name),
                            subtitle: Text(location.type),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(location.rating.toString()),
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _showLocationDetails(location);
                            },
                          ),
                        );
                      },
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) =>
                        Center(child: Text('Error: $error')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
