import '../logging/ai_logger.dart';

class PerformanceMetrics {
  Duration? modelLoadTime;
  Duration? firstTokenTime;
  double? tokensPerSecond;
  int? ramUsageMB;
  double? cpuUsage;
  int? contextTokens;
  int? responseTokens;
  DateTime? startTime;
  DateTime? firstTokenAt;
  int tokenCount = 0;

  Map<String, dynamic> toJson() => {
    'modelLoadTimeMs': modelLoadTime?.inMilliseconds,
    'firstTokenTimeMs': firstTokenTime?.inMilliseconds,
    'tokensPerSecond': tokensPerSecond,
    'ramUsageMB': ramUsageMB,
    'responseTokens': responseTokens,
    'contextTokens': contextTokens,
  };

  @override
  String toString() => toJson().toString();
}

class PerformanceTracker {
  static final PerformanceTracker _instance = PerformanceTracker._internal();
  factory PerformanceTracker() => _instance;
  PerformanceTracker._internal();

  PerformanceMetrics current = PerformanceMetrics();
  final List<PerformanceMetrics> history = [];

  void startLoad() {
    current = PerformanceMetrics();
    current.startTime = DateTime.now();
    AILogger.runtime("[PERF] Model loading started...");
  }

  void endLoad() {
    if (current.startTime != null) {
      current.modelLoadTime = DateTime.now().difference(current.startTime!);
      AILogger.runtime("[PERF][Load] Model loaded in \${current.modelLoadTime!.inMilliseconds}ms");
    }
  }

  void startGeneration() {
    current.firstTokenAt = null;
    current.tokenCount = 0;
    current.startTime = DateTime.now();
    AILogger.runtime("[PERF] Generation started...");
  }

  void onFirstToken() {
    if (current.firstTokenAt == null && current.startTime != null) {
      current.firstTokenAt = DateTime.now();
      current.firstTokenTime = current.firstTokenAt!.difference(current.startTime!);
      AILogger.runtime("[PERF][FirstToken] \${current.firstTokenTime!.inMilliseconds}ms");
    }
  }

  void onToken() {
    if (current.tokenCount == 0) onFirstToken();
    current.tokenCount++;
  }

  void endGeneration() {
    if (current.startTime != null && current.firstTokenAt != null) {
      final totalTime = DateTime.now().difference(current.firstTokenAt!).inMilliseconds / 1000;
      if (totalTime > 0) {
        current.tokensPerSecond = current.tokenCount / totalTime;
        current.responseTokens = current.tokenCount;
        AILogger.runtime("[PERF][TPS] \${current.tokensPerSecond!.toStringAsFixed(1)} tokens/sec (\${current.tokenCount} tokens in \${totalTime.toStringAsFixed(2)}s)");
      }
    }
    history.add(current);
    AILogger.runtime("[PERF] Metrics: \${current.toJson()}");
  }

  void reset() {
    current = PerformanceMetrics();
  }
}
