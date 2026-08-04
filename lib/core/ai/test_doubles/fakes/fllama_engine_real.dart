// Real Fllama Engine - To be used when fllama package is actually added
// This is the real implementation that will replace simulated one after first phone run succeeds

/*
import 'package:fllama/fllama.dart';
import '../../logging/ai_logger.dart';
import '../../performance/performance_tracker.dart';
import '../runtime_state.dart';
import '../runtime_capabilities.dart';

class FllamaEngineReal {
  final RuntimeStateMachine _stateMachine = RuntimeStateMachine();
  String? _modelPath;
  Fllama? _fllamaInstance;

  RuntimeState get state => _stateMachine.state;
  bool get isLoaded => _stateMachine.isLoaded;
  RuntimeCapabilities get capabilities => RuntimeCapabilities.fllamaQwen;

  Future<void> loadModel(String path) async {
    AILogger.runtime("[FllamaEngineReal] loadModel() path=\$path");
    _stateMachine.ensureCanLoad();
    _stateMachine.transition(RuntimeState.loading);
    PerformanceTracker().startLoad();
    AILogger.runtime("[Runtime] Loading model...");

    try {
      _modelPath = path;
      _fllamaInstance = Fllama();
      await _fllamaInstance!.loadModel(path, maxContext: capabilities.maxContextLength ?? 2048);

      _stateMachine.transition(RuntimeState.loaded);
      PerformanceTracker().endLoad();
      AILogger.runtime("[Runtime] Model loaded - \${PerformanceTracker().current.modelLoadTime?.inMilliseconds}ms");
    } catch (e, stack) {
      _stateMachine.transition(RuntimeState.error, error: e.toString(), stack: stack);
      AILogger.error("FllamaEngineReal", "load failed -> Error", e);
      rethrow;
    }
  }

  Stream<String> generate(String prompt, {int maxTokens = 512}) async* {
    _stateMachine.ensureCanGenerate();
    _stateMachine.transition(RuntimeState.generating);
    PerformanceTracker().startGeneration();
    AILogger.runtime("[Runtime] First token ... generating");

    try {
      final stream = _fllamaInstance!.generateStream(prompt, maxTokens: maxTokens);
      await for (final token in stream) {
        PerformanceTracker().onToken();
        if (PerformanceTracker().current.tokenCount == 1) {
          AILogger.runtime("[Runtime] First token ... \${PerformanceTracker().current.firstTokenTime?.inMilliseconds}ms");
        }
        yield token;
      }
      _stateMachine.transition(RuntimeState.idle);
      PerformanceTracker().endGeneration();
      AILogger.runtime("[Runtime] Generation completed - \${PerformanceTracker().current.tokensPerSecond?.toStringAsFixed(1)} TPS");
    } catch (e, stack) {
      _stateMachine.transition(RuntimeState.error, error: e.toString(), stack: stack);
      rethrow;
    }
  }

  Future<void> dispose() async {
    if (_stateMachine.state == RuntimeState.disposed) return;
    _stateMachine.transition(RuntimeState.unloading);
    await _fllamaInstance?.unloadModel();
    _modelPath = null;
    _stateMachine.transition(RuntimeState.disposed);
  }
}
*/

/// Placeholder for now - simulated version is in fllama_engine.dart
/// After first phone run succeeds, replace fllama_engine.dart content with real implementation above
class FllamaEngineRealPlaceholder {
  static const String note = "Real implementation commented above - will be activated after first phone run test with Fake succeeds";
}
