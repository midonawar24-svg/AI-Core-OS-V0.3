import '../../logging/ai_logger.dart';
import '../../performance/performance_tracker.dart';
import '../runtime_state.dart';

/// FllamaEngine - Wrapper Layer
/// كل التعامل المباشر مع fllama package هنا فقط
/// لو بعد سنة حبيت تستخدم llama.cpp أو MLC LLM، تغير الـ Engine فقط، الـ Adapter يفضل ثابت

class FllamaEngine {
  final RuntimeStateMachine _stateMachine = RuntimeStateMachine();
  String? _modelPath;

  RuntimeState get state => _stateMachine.state;
  bool get isLoaded => _stateMachine.isLoaded;
  String? get modelPath => _modelPath;

  /// Direct fllama interaction - loadModel
  Future<void> loadModel(String path) async {
    AILogger.runtime("[FllamaEngine] loadModel() path=\$path, currentState=\${_stateMachine.state}");
    _stateMachine.ensureCanLoad();
    _stateMachine.transition(RuntimeState.loading);
    PerformanceTracker().startLoad();

    try {
      // TODO: Real fllama integration - uncomment when package added
      // import 'package:fllama/fllama.dart';
      // await Fllama.loadModel(path);

      // Simulate real loading for now (will be replaced)
      _modelPath = path;
      await Future.delayed(Duration(milliseconds: 1200)); // Simulate 1.2s load

      _stateMachine.transition(RuntimeState.loaded);
      PerformanceTracker().endLoad();
      AILogger.runtime("[FllamaEngine] Model loaded - state=\${_stateMachine.state}");
    } catch (e, stack) {
      _stateMachine.transition(RuntimeState.error, error: e.toString());
      AILogger.error("FllamaEngine", "loadModel failed", e);
      rethrow;
    }
  }

  /// Direct fllama interaction - generate (streaming)
  Stream<String> generate(String prompt, {int maxTokens = 512}) async* {
    AILogger.runtime("[FllamaEngine] generate() prompt=\${prompt.length} chars, maxTokens=\$maxTokens, state=\${_stateMachine.state}");
    _stateMachine.ensureCanGenerate();
    _stateMachine.transition(RuntimeState.generating);
    PerformanceTracker().startGeneration();

    try {
      // TODO: Real fllama streaming - uncomment when package added
      // final stream = Fllama.generateStream(prompt, maxTokens: maxTokens);
      // await for (final token in stream) {
      //   PerformanceTracker().onToken();
      //   yield token;
      // }

      // Simulated real model response (Qwen2.5-0.5B style) - will be replaced
      final simulatedTokens = [
        "أهلاً", " بك!", " أنا", " Qwen2.5-0.5B", " يعمل", " الآن", " محليًا", " على", " جهازك",
        " بدون", " إنترنت.", " المعمارية", " نجحت:", " فصلنا", " الـEngine", " عن", " الـAdapter.",
        " لو", " بعد", " سنة", " حبيت", " تستخدم", " llama.cpp", " أو", " MLC", " LLM,",
        " هتغير", " الـEngine", " فقط.", " الـAdapter", " يفضل", " ثابت", " لأنه", " ينفذ", " عقد", " ChatRuntime.",
        " هذا", " هو", " الفرق", " بين", " Framework", " و", " تطبيق", " دردشة.",
        " [State:", " Loaded", " ->", " Generating", " ->", " Idle]",
        " [PERF:", " FirstToken", " 342ms,", " TPS", " 14.2]"
      ];

      for (var token in simulatedTokens) {
        await Future.delayed(Duration(milliseconds: 75)); // ~13.3 TPS
        PerformanceTracker().onToken();
        yield token + " ";
      }

      _stateMachine.transition(RuntimeState.idle);
      PerformanceTracker().endGeneration();
      AILogger.runtime("[FllamaEngine] Generation completed - state=\${_stateMachine.state}");
    } catch (e, stack) {
      _stateMachine.transition(RuntimeState.error, error: e.toString());
      AILogger.error("FllamaEngine", "generate failed", e);
      rethrow;
    }
  }

  /// Direct fllama interaction - dispose
  Future<void> dispose() async {
    AILogger.runtime("[FllamaEngine] dispose() - path=\$_modelPath, state=\${_stateMachine.state}");
    if (_stateMachine.state == RuntimeState.disposed) return;

    _stateMachine.transition(RuntimeState.unloading);
    try {
      // TODO: await Fllama.unloadModel();
      await Future.delayed(Duration(milliseconds: 200));
      _modelPath = null;
      _stateMachine.transition(RuntimeState.disposed);
      AILogger.runtime("[FllamaEngine] Disposed - state=\${_stateMachine.state}");
    } catch (e) {
      _stateMachine.transition(RuntimeState.error, error: e.toString());
      AILogger.error("FllamaEngine", "dispose failed", e);
    }
  }
}
