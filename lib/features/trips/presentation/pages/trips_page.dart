import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/trips/trips_bloc.dart';
import '../widgets/trips_view.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<TripsBloc>()..add(const TripsStarted()),
      child: const TripsView(),
    );
  }
}
