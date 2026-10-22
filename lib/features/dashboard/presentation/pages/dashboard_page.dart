import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/kpi_range.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/trip_chart/trip_chart_bloc.dart';

import '../widgets/dashboard_view.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<DashboardBloc>()..add(const DashboardStarted()),
        ),
        BlocProvider(
          create: (_) =>
              sl<TripChartBloc>()
                ..add(const TripChartRangeSelected(KpiRange.last24Hours)),
        ),
      ],
      child: const DashboardView(),
    );
  }
}
