import '../../contracts/ai_context.dart';
import '../../logging/ai_logger.dart';
import '../pipeline/context_stage.dart';

class PluginStage implements ContextStage {
  @override
  Future<AIContext> call(AIContext context) async {
    AILogger.pipeline("PluginStage: no plugins (v0.2.0)");
    return context;
  }
}
