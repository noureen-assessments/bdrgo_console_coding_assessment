import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/maintenance_bloc.dart';


class MaintenanceEndedListener extends StatelessWidget {
  const MaintenanceEndedListener({
    required this.onEnded,
    required this.child,
    super.key,
  });

  final VoidCallback onEnded;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MaintenanceBloc, MaintenanceState>(
      listenWhen: (previous, current) =>
          previous is MaintenanceOn && current is MaintenanceOff,
      listener: (_, _) => onEnded(),
      child: child,
    );
  }
}
