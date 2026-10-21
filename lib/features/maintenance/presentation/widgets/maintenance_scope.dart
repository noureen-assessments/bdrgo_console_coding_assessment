import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/maintenance_bloc.dart';
import 'maintenance_view.dart';

class MaintenanceScope extends StatelessWidget {
  const MaintenanceScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MaintenanceBloc, MaintenanceState>(
      builder: (context, state) => Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(ignoring: state is MaintenanceOn, child: child),
          if (state is MaintenanceOn)
            Material(child: MaintenanceView(info: state.info)),
        ],
      ),
    );
  }
}
