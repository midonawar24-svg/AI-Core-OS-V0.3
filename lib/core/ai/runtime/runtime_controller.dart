import 'dart:async';
import '../contracts/runtimes.dart';
import 'runtime_events.dart';

class RuntimeController {
  final ChatRuntime chatRuntime;
  final EmbeddingRuntime embeddingRuntime;
  final _events = StreamController<RuntimeEvent>.broadcast();
  Stream<RuntimeEvent> get events => _events.stream;

  RuntimeController({required this.chatRuntime, required this.embeddingRuntime});

  Future<void> loadChatModel(String absolutePath) async {
    _events.add(ModelLoading(absolutePath));
    try {
      await chatRuntime.load(absolutePath);
      _events.add(ModelLoaded(absolutePath));
      _events.add(RuntimeReady());
    } catch(e) {
      _events.add(ModelFailed(absolutePath, e.toString()));
    }
  }

  Future<void> unload() async {
    await chatRuntime.unload();
    await embeddingRuntime.unload();
  }

  void dispose() => _events.close();
}
