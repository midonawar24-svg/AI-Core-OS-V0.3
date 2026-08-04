class AICoreConfig {
  final bool useFakeRuntime;
  final String modelPath;
  final bool enablePerformanceTracking;
  final bool enableLogger;

  AICoreConfig({
    this.useFakeRuntime = true, // Default true for safety - v0.2.0
    this.modelPath = "/models/qwen2.5-0.5b.gguf",
    this.enablePerformanceTracking = true,
    this.enableLogger = true,
  });

  static AICoreConfig defaultConfig() => AICoreConfig();

  static AICoreConfig fakeConfig() => AICoreConfig(useFakeRuntime: true);

  static AICoreConfig realConfig({String? modelPath}) => AICoreConfig(
    useFakeRuntime: false,
    modelPath: modelPath ?? "/models/qwen2.5-0.5b.gguf",
    enablePerformanceTracking: true,
  );

  AICoreConfig copyWith({bool? useFakeRuntime, String? modelPath}) {
    return AICoreConfig(
      useFakeRuntime: useFakeRuntime ?? this.useFakeRuntime,
      modelPath: modelPath ?? this.modelPath,
      enablePerformanceTracking: enablePerformanceTracking,
      enableLogger: enableLogger,
    );
  }
}
