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
import '../test_doubles/fakes/fake_chat_runtime.dart';
import '../runtime/adapters/fllama_chat_adapter.dart';
import '../test_doubles/fakes/fake_embedding_runtime.dart';
import '../logging/ai_logger.dart';

/// Production Bootstrap - v0.3.0 will swap Fake -> Fllama here only

class ProductionBootstrap {
  static AiCoreKernel build({bool useRealModel = false}) {
    AILogger.bootstrap("Building Kernel - useRealModel=\$useRealModel");

    final registry = ModelRegistry();
    registry.register(ModelSpec(
      id: useRealModel ? "qwen2.5-0.5b-real" : "qwen2.5-0.5b-fake",
      family: ModelFamily.qwen,
      type: ModelType.chat,
      absolutePath: useRealModel ? "/models/qwen2.5-0.5b.gguf" : "/fake/path",
      promptTemplateId: "qwen2.5",
      capabilities: ModelCapabilities.chatDefault(),
    ));

    // KEY: Only this line changes between v0.2.0 and v0.3.0
    final chatRuntime = useRealModel ? FllamaChatRuntime() : FakeChatRuntime();

    AILogger.bootstrap("ChatRuntime: \${chatRuntime.runtimeType} - \${useRealModel ? 'REAL MODEL' : 'FAKE'}");

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
