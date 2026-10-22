final class Backoff {
  const Backoff({
    this.initial = const Duration(seconds: 1),
    this.max = const Duration(seconds: 30),
  });

  final Duration initial;
  final Duration max;

  Duration delay(int attempt) {
    var delay = initial;
    for (var i = 0; i < attempt && delay < max; i++) {
      delay *= 2;
    }
    return delay > max ? max : delay;
  }
}
