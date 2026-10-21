import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/alerts/alerts_bloc.dart';
import '../widgets/alerts_view.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AlertsBloc>()..add(const AlertsStarted()),
      child: const AlertsView(),
    );
  }
}
