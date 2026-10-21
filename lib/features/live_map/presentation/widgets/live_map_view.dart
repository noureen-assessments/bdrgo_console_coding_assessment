import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/live_map/live_map_bloc.dart';
import 'live_map_content.dart';
import 'live_map_layout.dart';

class LiveMapView extends StatelessWidget {
  const LiveMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveMapBloc, LiveMapState>(
      builder: (context, state) => switch (state) {
        LiveMapLoading() => const Center(child: CircularProgressIndicator()),
        final LiveMapLoaded loaded => LiveMapLayout(
          map: LiveMapContent(drivers: loaded.drivers, isLive: loaded.isLive),
        ),
      },
    );
  }
}
