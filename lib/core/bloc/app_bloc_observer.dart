import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/log_constants.dart';
import '../utils/logger.dart';


final class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLogger.info(LogMessages.blocEvent(bloc, event), name: LogTags.bloc);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.error(
      LogMessages.blocFailed(bloc),
      name: LogTags.bloc,
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
