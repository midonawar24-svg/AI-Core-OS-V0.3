import '../../contracts/ai_context.dart';

abstract class PromptTemplate {
  String build(AIContext context);
}

class QwenTemplate implements PromptTemplate {
  @override
  String build(AIContext context) {
    final buffer = StringBuffer();
    buffer.writeln("<|im_start|>system");
    for (var entry in context.entries) {
      if (entry.type == ContextEntryType.system) {
        buffer.writeln(entry.content);
      }
    }
    buffer.writeln("<|im_end|>");

    for (var entry in context.entries) {
      if (entry.type == ContextEntryType.conversation) {
        buffer.writeln("<|im_start|>user");
        buffer.writeln(entry.content);
        buffer.writeln("<|im_end|>");
      }
    }

    buffer.writeln("<|im_start|>user");
    buffer.writeln(context.rawQuery);
    buffer.writeln("<|im_end|>");
    buffer.writeln("<|im_start|>assistant");
    return buffer.toString();
  }
}
