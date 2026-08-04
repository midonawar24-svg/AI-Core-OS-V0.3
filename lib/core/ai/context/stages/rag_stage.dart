import '../../contracts/ai_context.dart';
import '../../contracts/vector_store.dart';
import '../../logging/ai_logger.dart';
import '../pipeline/context_stage.dart';

class RagStage implements ContextStage {
  final VectorStore vectorStore;
  RagStage({required this.vectorStore});

  @override
  Future<AIContext> call(AIContext context) async {
    AILogger.pipeline("RagStage: searching vector store");
    AILogger.memory("RagStage: found 0 docs (InMemory - v0.2.0)");
    return context;
  }
}
