import 'dart:async';
import 'runtime_events.dart';
import 'runtime_state.dart';

class RuntimeController {
  final StreamController<RuntimeEvent> _controller = StreamController<RuntimeEvent>.broadcast();
  Stream<RuntimeEvent> get events => _controller.stream;

  RuntimeState _state = const RuntimeState.idle();
  RuntimeState get state => _state;

  void emit(RuntimeEvent event) {
    _controller.add(event);
    if (event is ModelLoading) {
      _state = const RuntimeState.loading();
    } else if (event is ModelLoaded) {
      _state = const RuntimeState.ready();
    } else if (event is RuntimeReady) {
      _state = const RuntimeState.ready();
    } else if (event is ModelFailed) {
      _state = const RuntimeState.failed();
    }
  }

  // Backward compat - old code called controller.ModelLoading() as method
  void ModelLoading() => emit(const ModelLoading());
  void ModelLoaded() => emit(const ModelLoaded());
  void RuntimeReady() => emit(const RuntimeReady());
  void ModelFailed([String error = 'unknown']) => emit(ModelFailed(error));

  void dispose() {
    _controller.close();
  }
}
