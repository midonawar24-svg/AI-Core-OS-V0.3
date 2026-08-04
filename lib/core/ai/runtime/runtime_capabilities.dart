/// RuntimeCapabilities - Each Runtime declares its capabilities
/// Core knows capabilities without any if(Fake/Fllama)

class RuntimeCapabilities {
  final bool supportsStreaming;
  final bool supportsCancellation;
  final bool supportsEmbeddings;
  final bool supportsVision;
  final bool supportsChat;
  final int? maxContextLength;
  final int? maxTokens;
  final String modelType; // "qwen", "llama", "mistral", etc
  final bool isLocal; // true = on-device, false = cloud

  const RuntimeCapabilities({
    this.supportsStreaming = true,
    this.supportsCancellation = false,
    this.supportsEmbeddings = false,
    this.supportsVision = false,
    this.supportsChat = true,
    this.maxContextLength,
    this.maxTokens,
    this.modelType = "unknown",
    this.isLocal = true,
  });

  static const fake = RuntimeCapabilities(
    supportsStreaming: true,
    supportsCancellation: false,
    supportsEmbeddings: false,
    supportsVision: false,
    supportsChat: true,
    maxContextLength: 2048,
    maxTokens: 512,
    modelType: "fake",
    isLocal: true,
  );

  static const fllamaQwen = RuntimeCapabilities(
    supportsStreaming: true,
    supportsCancellation: true,
    supportsEmbeddings: false,
    supportsVision: false,
    supportsChat: true,
    maxContextLength: 2048,
    maxTokens: 1024,
    modelType: "qwen",
    isLocal: true,
  );

  static const fllamaLlama = RuntimeCapabilities(
    supportsStreaming: true,
    supportsCancellation: true,
    supportsEmbeddings: false,
    supportsVision: false,
    supportsChat: true,
    maxContextLength: 4096,
    maxTokens: 2048,
    modelType: "llama",
    isLocal: true,
  );

  Map<String, dynamic> toJson() => {
    'supportsStreaming': supportsStreaming,
    'supportsChat': supportsChat,
    'maxContextLength': maxContextLength,
    'modelType': modelType,
    'isLocal': isLocal,
  };

  @override
  String toString() => "RuntimeCapabilities(\$modelType, streaming=\$supportsStreaming, context=\$maxContextLength)";
}
