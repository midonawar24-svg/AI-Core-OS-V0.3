import '../../contracts/ai_context.dart';
import '../../logging/ai_logger.dart';
import '../pipeline/context_stage.dart';

class SystemStage implements ContextStage {
  @override
  Future<AIContext> call(AIContext context) async {
    AILogger.pipeline("SystemStage: adding system prompt");
    final entry = ContextEntry(
      id: "system",
      type: ContextEntryType.system,
      source: ContextSource.system,
      content: "You are AI Core OS assistant, helpful and concise.",
    );
    return context.copyWith(entries: [...context.entries, entry]);
  }
}
