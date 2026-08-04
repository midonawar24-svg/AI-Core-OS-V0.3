import '../runtime/runtime_capabilities.dart';

abstract class ChatRuntime {
  Future<void> load(String path);
  Stream<String> generate(String prompt);
  Future<void> unload();

  // NEW: Each runtime declares its capabilities - no if needed outside
  RuntimeCapabilities get capabilities;
}

abstract class EmbeddingRuntime {
  Future<void> load(String path);
  Future<List<double>> embed(String text);
  Future<void> unload();
  RuntimeCapabilities get capabilities => RuntimeCapabilities(supportsEmbeddings: true, supportsChat: false);
}
