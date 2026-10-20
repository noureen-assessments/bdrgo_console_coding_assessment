import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/trip_detail/trip_detail_bloc.dart';
import '../widgets/trip_detail_body.dart';

class TripDetailPage extends StatelessWidget {
  const TripDetailPage({required this.tripId, super.key});

  final String tripId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TripDetailBloc>()..add(TripDetailStarted(tripId)),
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.tripDetailTitle)),
        body: TripDetailBody(tripId: tripId),
      ),
    );
  }
}
