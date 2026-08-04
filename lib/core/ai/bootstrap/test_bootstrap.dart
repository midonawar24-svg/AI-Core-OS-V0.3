import '../config/ai_core_config.dart';
import '../memory/in_memory_store.dart';
import '../memory/in_memory_vector_store.dart';
import '../context/pipeline/context_stage.dart';
import '../context/stages/conversation_stage.dart';
import '../context/stages/system_stage.dart';
import '../context/stages/memory_stage.dart';
import '../context/stages/rag_stage.dart';
import '../context/stages/plugin_stage.dart';
import '../prompt/registry/template_registry.dart';
import '../prompt/templates/qwen_template.dart';
import '../prompt/prompt_builder.dart';
import '../runtime/runtime_controller.dart';
import '../kernel/ai_core_kernel.dart';
import '../models/model_family.dart';
import '../../test_doubles/fakes/fake_chat_runtime.dart';
import '../../test_doubles/fakes/fake_embedding_runtime.dart';

class TestBootstrap {
  static AiCoreKernel buildForTest() {
    final registry = ModelRegistry();
    registry.register(ModelSpec(
      id: "qwen2.5-0.5b-test",
      family: ModelFamily.qwen,
      type: ModelType.chat,
      absolutePath: "/fake/path",
      promptTemplateId: "qwen2.5",
      capabilities: ModelCapabilities.chatDefault(),
    ));

    final chatRuntime = FakeChatRuntime();
    final embeddingRuntime = FakeEmbeddingRuntime();
    final runtimeController = RuntimeController(
      chatRuntime: chatRuntime,
      embeddingRuntime: embeddingRuntime,
    );

    final memoryStore = InMemoryStore();
    final vectorStore = InMemoryVectorStore();

    final pipeline = ContextPipeline(stages: [
      ConversationStage(),
      SystemStage(),
      MemoryStage(memoryStore: memoryStore),
      RagStage(vectorStore: vectorStore),
      PluginStage(),
    ]);

    final templateRegistry = TemplateRegistry();
    templateRegistry.register("qwen2.5", QwenTemplate());
    final promptBuilder = PromptBuilder(templateRegistry);

    return AiCoreKernel(
      contextPipeline: pipeline,
      promptBuilder: promptBuilder,
      runtimeController: runtimeController,
      registry: registry,
    );
  }
}
