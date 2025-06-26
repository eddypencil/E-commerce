import 'package:e_commerce/features/map/presentation/cubit/locationCubit.dart';
import 'package:e_commerce/features/map/presentation/cubit/markerCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  late LocationCubit _locationCubit;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    context.read<LocationCubit>().startTrackingLocation();
  }

  @override
void didChangeDependencies() {
   
  super.didChangeDependencies();
  _locationCubit = context.read<LocationCubit>();
}

  @override
  void dispose() {
    _locationCubit.stopTrackingLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, locationState) {
          if (locationState is LocationLoaded) {
            Future.delayed(const Duration(milliseconds: 200), () {
              _mapController.move(
                LatLng(
                  locationState.position.latitude,
                  locationState.position.longitude,
                ),
                16.2,
              );
            });

            return BlocBuilder<MarkersCubit, MarkersState>(
              builder: (context, markersState) {
                List<Marker> markers = [];

                if (markersState is LoadMarkers) {
                  markers = markersState.markersList.map((markerData) {
                    return Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                        markerData.marker.latitude,
                        markerData.marker.longitude,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.location_on,
                          color: const Color(0xffFF3D00),
                          size: MediaQuery.of(context).size.width * 0.1,
                        ),
                        onPressed: () {
                          _showMarkerDetailsBottomSheet(context, markerData.title, markerData.description, markerData.id);
                        },
                      ),
                    );
                  }).toList();
                }

                return FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    onTap: (tapPosition, point) {
                      _showAddMarkerBottomSheet(context, point);
                    },
                    minZoom: 4.0,
                    maxZoom: 18.0,
                    initialCenter: LatLng(
                      locationState.position.latitude,
                      locationState.position.longitude,
                    ),
                    initialZoom: 16.2,
                    backgroundColor: const Color(0xffE5E7EB),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(
                            locationState.position.latitude,
                            locationState.position.longitude,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                            decoration: BoxDecoration(
                              color: const Color(0xff00BFFF),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                        ...markers,
                      ],
                    ),
                  ],
                );
              },
            );
          } else if (locationState is LocationError) {
            return Center(child: Text(locationState.errorMessage));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoomOut',
            onPressed: () {
              double currentZoom = _mapController.camera.zoom;
              if (currentZoom > 4.0) {
                _mapController.move(
                  _mapController.camera.center,
                  currentZoom - 2.0,
                );
              }
            },
            backgroundColor: const Color(0xffE5E7EB),
            child: Icon(
              Icons.remove,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'zoomIn',
            elevation: 8,
            onPressed: () {
              double currentZoom = _mapController.camera.zoom;
              if (currentZoom < 18.0) {
                _mapController.move(
                  _mapController.camera.center,
                  currentZoom + 2.0,
                );
              }
            },
            backgroundColor: const Color(0xffE5E7EB),
            child: Icon(
              Icons.add,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMarkerBottomSheet(BuildContext context, LatLng point) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final markersCubit = context.read<MarkersCubit>();

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: markersCubit,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  "Add Marker",
                  style:GoogleFonts.onest(fontSize: 24.sp, fontWeight: FontWeight.bold) 
                
                ),
                const SizedBox(height: 6),
                Text("Do you want to add this location?",style:GoogleFonts.onest(fontSize: 14.sp, fontWeight: FontWeight.bold,color: Colors.grey[600])),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Marker Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xff00BFFF), width: 2),
                    ),
                    prefixIcon: const Icon(Icons.title),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blue, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.description),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 6,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:  Text(
                        "  Cancel  ",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 6,
                        backgroundColor:  Colors.grey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        final String title = titleController.text.trim();
                        final String description = descriptionController.text.trim();
                        markersCubit.addMarker(point, title, description);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Add Marker",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMarkerDetailsBottomSheet(
    BuildContext context,
    String title,
    String description,
    String id,
  ) {
    final markersCubit = context.read<MarkersCubit>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: markersCubit,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        markersCubit.removeMarker(id);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        FontAwesomeIcons.trash,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
