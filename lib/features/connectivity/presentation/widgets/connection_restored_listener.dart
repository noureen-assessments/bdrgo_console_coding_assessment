import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/connectivity_bloc.dart';


class ConnectionRestoredListener extends StatelessWidget {
  const ConnectionRestoredListener({
    required this.onRestored,
    required this.child,
    super.key,
  });

  final VoidCallback onRestored;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listenWhen: (previous, current) =>
          previous is ConnectivityOffline && current is ConnectivityOnline,
      listener: (_, _) => onRestored(),
      child: child,
    );
  }
}
