import '../../contracts/ai_context.dart';
abstract class ContextStage { Future<AIContext> execute(AIContext context); }

class ContextPipeline {
  final List<ContextStage> stages;
  ContextPipeline({required this.stages});
  Future<AIContext> build(String query, String conversationId) async {
    var ctx = AIContext(rawQuery: query, conversationId: conversationId);
    for(final stage in stages){
      try { ctx = await stage.execute(ctx); } catch(e){ /* log and continue */ }
    }
    return ctx;
  }
}
