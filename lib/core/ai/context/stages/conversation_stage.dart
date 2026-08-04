import '../../contracts/ai_context.dart';
import '../../logging/ai_logger.dart';
import '../pipeline/context_stage.dart';

class ConversationStage implements ContextStage {
  @override
  Future<AIContext> call(AIContext context) async {
    AILogger.pipeline("ConversationStage: processing '\${context.rawQuery}'");
    final entry = ContextEntry(
      id: "conv_\${DateTime.now().millisecondsSinceEpoch}",
      type: ContextEntryType.conversation,
      source: ContextSource.conversation,
      content: context.rawQuery,
    );
    final result = context.copyWith(entries: [...context.entries, entry]);
    AILogger.memory("ConversationStage: added entry, total \${result.entries.length}");
    return result;
  }
}
