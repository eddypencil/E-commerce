import 'package:e_commerce/core/constants/Transtions.dart';
import 'package:e_commerce/features/map/presentation/cubit/locationCubit.dart';
import 'package:e_commerce/features/map/presentation/cubit/markerCubit.dart';
import 'package:e_commerce/features/map/presentation/screens/screen_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({Key? key}) : super(key: key);

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Locations"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final _locationCubit = context.read<LocationCubit>();
              final _markerCubit = context.read<MarkersCubit>();

              Navigator.push(
                context,
                SlideInPageRoute(
                  page: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: _locationCubit),
                      BlocProvider.value(value: _markerCubit),
                    ],
                    child: const MapScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MarkersCubit, MarkersState>(
        builder: (context, state) {
          if (state is IsLoadingMarkers) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadMarkers && state.markersList.isNotEmpty) {
            return ListView.builder(
              itemCount: state.markersList.length,
              itemBuilder: (context, index) {
                final marker = state.markersList[index];
                return AnimatedMarkerTile(
                  key: ValueKey(marker.id),
                  title: marker.title,
                  description: marker.description,
                  onDelete: () async {
                    // Remove after animation delay
                    context.read<MarkersCubit>().removeMarker(marker.id);
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text("No locations saved."),
            );
          }
        },
      ),
    );
  }
}

class AnimatedMarkerTile extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback onDelete;

  const AnimatedMarkerTile({
    required this.title,
    required this.description,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedMarkerTile> createState() => _AnimatedMarkerTileState();
}

class _AnimatedMarkerTileState extends State<AnimatedMarkerTile>
    with TickerProviderStateMixin {



  late AnimationController _exitController;
  late Animation<Offset> _exitAnimation;

  

  @override
  void initState() {
    super.initState();


    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _exitAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-2, 0),
    ).animate(CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeIn,
    ));

   
  }

  @override
  void dispose() {
   
    _exitController.dispose();
    super.dispose();
  }

  void _handleDelete() async {
    

    await _exitController.forward(); // Animate to left
    widget.onDelete(); // Then remove from Cubit
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position:  _exitAnimation ,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          title: Text(widget.title),
          subtitle: Text(widget.description),
          trailing: IconButton(
            icon:  Icon(Icons.delete, color: Colors.grey[600]),
            onPressed: _handleDelete,
          ),
        ),
      ),
    );
  }
}
