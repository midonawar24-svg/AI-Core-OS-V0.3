import '../config/ai_core_config.dart';
import '../contracts/embedding_service.dart';
import '../contracts/runtimes.dart';
import '../models/model_family.dart';
import '../memory/in_memory_store.dart';
import '../memory/in_memory_vector_store.dart';
import '../context/pipeline/context_stage.dart';
import '../context/stages/conversation_stage.dart';
import '../context/stages/system_stage.dart';
import '../context/stages/memory_stage.dart';
import '../context/stages/rag_stage.dart';
import '../context/stages/plugin_stage.dart';
import '../prompt/registry/template_registry.dart';
import '../prompt/prompt_builder.dart';
import '../runtime/runtime_controller.dart';
import '../runtime/adapters/fllama_chat_adapter.dart';
import '../runtime/adapters/nomic_embedding_adapter.dart';
import '../kernel/ai_core_kernel.dart';

class AiCoreBootstrap {
  Future<AiCoreKernel> build(AICoreConfig config) async {
    final modelRegistry = ModelRegistry();
    modelRegistry.register(ModelSpec(id: "qwen2.5-0.5b", family: ModelFamily.qwen, type: ModelType.chat, absolutePath: "/models/qwen.gguf", promptTemplateId: "qwen2.5", capabilities: ModelCapabilities.chatDefault()));

    final chatRuntime = FllamaChatAdapter();
    final embeddingRuntime = NomicEmbeddingAdapter();
    final embeddingService = DefaultEmbeddingService(embeddingRuntime);
    final runtimeController = RuntimeController(chatRuntime: chatRuntime, embeddingRuntime: embeddingRuntime);

    final memoryStore = InMemoryStore();
    final vectorStore = InMemoryVectorStore();

    final contextPipeline = ContextPipeline(stages: [
      ConversationStage(),
      SystemStage(),
      MemoryStage(memoryStore, vectorStore, embeddingService),
      RagStage(),
      PluginStage(),
    ]);

    final templateRegistry = TemplateRegistry()
      ..register("qwen2.5", Qwen25Template())
      ..register("llama3", Llama3Template());

    final promptBuilder = PromptBuilder(templateRegistry);

    return AiCoreKernel(contextPipeline: contextPipeline, promptBuilder: promptBuilder, runtimeController: runtimeController, registry: modelRegistry);
  }

  static AiCoreBootstrap test({required AICoreConfig config, required ChatRuntime chatRuntime, required EmbeddingService embeddingService, required MemoryStore memoryStore, required VectorStore vectorStore}) {
    return AiCoreBootstrap();
  }
}
