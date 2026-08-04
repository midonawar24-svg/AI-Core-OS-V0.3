import '../contracts/ai_context.dart';
import '../context/pipeline/context_stage.dart';
import '../prompt/prompt_builder.dart';
import '../runtime/runtime_controller.dart';
import '../models/model_family.dart';

class AiCoreKernel {
  final ContextPipeline contextPipeline;
  final PromptBuilder promptBuilder;
  final RuntimeController runtimeController;
  final ModelRegistry registry;

  AiCoreKernel({
    required this.contextPipeline,
    required this.promptBuilder,
    required this.runtimeController,
    required this.registry,
  });

  // Full path: Query -> Pipeline -> PromptBuilder -> Runtime (Streaming)
  Stream<String> process(String query, {String conversationId = "default", String promptTemplateId = "qwen2.5"}) async* {
    // 1. Build Context via Pipeline
    final AIContext ctx = await contextPipeline.build(query, conversationId);

    // 2. Build Prompt via Builder
    final String prompt = promptBuilder.build(promptTemplateId: promptTemplateId, context: ctx);

    // 3. Generate via Runtime (Streaming)
    yield* runtimeController.chatRuntime.generate(prompt);
  }

  // Helper to get last built context for Debug UI
  Future<AIContext> buildContextOnly(String query, {String conversationId = "default"}) {
    return contextPipeline.build(query, conversationId);
  }
}
