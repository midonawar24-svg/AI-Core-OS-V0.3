import '../contracts/ai_context.dart';
import '../logging/ai_logger.dart';
import 'registry/template_registry.dart';

class PromptBuilder {
  final TemplateRegistry registry;
  PromptBuilder(this.registry);

  String build({required String promptTemplateId, required AIContext context}) {
    AILogger.prompt("PromptBuilder: resolving templateId=\$promptTemplateId");

    final template = registry.get(promptTemplateId);
    if (template == null) {
      AILogger.prompt("PromptBuilder: template not found, using default");
      return _buildDefault(context);
    }

    AILogger.prompt("PromptBuilder: using \${template.runtimeType}");
    return template.build(context);
  }

  String _buildDefault(AIContext context) {
    final buffer = StringBuffer();
    for (var entry in context.entries) {
      buffer.writeln("\${entry.type}: \${entry.content}");
    }
    buffer.writeln("User: \${context.rawQuery}");
    return buffer.toString();
  }
}
