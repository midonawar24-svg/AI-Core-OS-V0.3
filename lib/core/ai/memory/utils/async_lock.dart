import 'dart:async';
class AsyncLock {
  Future<void> _last = Future.value();
  Future<T> synchronized<T>(Future<T> Function() fn) {
    var completer = Completer<T>();
    _last = _last.then((_) => fn().then(completer.complete).catchError(completer.completeError));
    return completer.future;
  }
}
