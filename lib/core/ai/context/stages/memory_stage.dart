import '../../contracts/ai_context.dart';
import '../../contracts/memory_store.dart';
import '../../logging/ai_logger.dart';
import '../pipeline/context_stage.dart';

class MemoryStage implements ContextStage {
  final MemoryStore memoryStore;
  MemoryStage({required this.memoryStore});

  @override
  Future<AIContext> call(AIContext context) async {
    AILogger.pipeline("MemoryStage: searching memories for '\${context.normalizedQuery}'");
    // Simplified - In real would search
    AILogger.memory("MemoryStage: found 0 memories (InMemory - v0.2.0)");
    return context;
  }
}
