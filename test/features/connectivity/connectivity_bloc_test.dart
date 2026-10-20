import 'package:badrgo_console_assesment/features/connectivity/domain/usecases/watch_connectivity_use_case.dart';
import 'package:badrgo_console_assesment/features/connectivity/presentation/bloc/connectivity_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes.dart';

void main() {
  late FakeConnectivity connectivity;

  setUp(() => connectivity = FakeConnectivity()..online = false);

  blocTest<ConnectivityBloc, ConnectivityState>(
    'starts with the current status, then follows changes',
    build: () => ConnectivityBloc(WatchConnectivityUseCase(connectivity)),
    act: (bloc) async {
      bloc.add(const ConnectivityStarted());
      await Future<void>.delayed(Duration.zero);
      connectivity.set(online: true);
    },
    expect: () => [const ConnectivityOffline(), const ConnectivityOnline()],
  );
}
