import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/driver_detail/driver_detail_bloc.dart';
import '../bloc/live_map/live_map_bloc.dart';
import '../widgets/live_map_view.dart';

class LiveMapPage extends StatelessWidget {
  const LiveMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<LiveMapBloc>()..add(const LiveMapStarted()),
        ),
        BlocProvider(create: (_) => sl<DriverDetailBloc>()),
      ],
      child: const LiveMapView(),
    );
  }
}
