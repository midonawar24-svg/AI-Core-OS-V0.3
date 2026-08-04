/// State Machine for Runtime - From Day 1
/// Uninitialized -> Loading -> Loaded -> Generating -> Idle -> Unloading -> Disposed

enum RuntimeState {
  uninitialized,
  loading,
  loaded,
  generating,
  idle,
  unloading,
  disposed,
  error;

  bool get canLoad => this == RuntimeState.uninitialized || this == RuntimeState.disposed || this == RuntimeState.error;
  bool get canGenerate => this == RuntimeState.loaded || this == RuntimeState.idle;
  bool get canUnload => this == RuntimeState.loaded || this == RuntimeState.idle || this == RuntimeState.error;
  bool get isBusy => this == RuntimeState.loading || this == RuntimeState.generating || this == RuntimeState.unloading;
}

class RuntimeStateMachine {
  RuntimeState _state = RuntimeState.uninitialized;
  String? _errorMessage;

  RuntimeState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoaded => _state == RuntimeState.loaded || _state == RuntimeState.idle;

  void transition(RuntimeState newState, {String? error}) {
    // Log transition
    // Valid transitions check could be added here
    _state = newState;
    _errorMessage = error;
  }

  void ensureCanLoad() {
    if (!state.canLoad) {
      throw StateError("Cannot load in state \$state - must be uninitialized/disposed/error");
    }
  }

  void ensureCanGenerate() {
    if (!state.canGenerate) {
      throw StateError("Cannot generate in state \$state - must be loaded/idle. Did you call load() first?");
    }
  }

  void ensureCanUnload() {
    if (!state.canUnload) {
      throw StateError("Cannot unload in state \$state");
    }
  }
}
