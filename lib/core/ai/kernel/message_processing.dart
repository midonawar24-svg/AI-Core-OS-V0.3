import '../contracts/ai_context.dart';
import '../logging/ai_logger.dart';
import 'ai_core_kernel.dart';

/// Message Processing - Single Entry Point for ALL clients
/// UI / API / CLI / Test / Desktop / Web / REST / Voice
/// كل الواجهات تستخدم نفس الـ API

class MessageRequest {
  final String query;
  final String conversationId;
  final String promptTemplateId;
  final Map<String, dynamic> extras;

  MessageRequest({
    required this.query,
    this.conversationId = "default",
    this.promptTemplateId = "qwen2.5",
    this.extras = const {},
  });
}

class MessageResponse {
  final Stream<String> stream;
  final Future<AIContext> contextFuture;

  MessageResponse({required this.stream, required this.contextFuture});
}

class MessageProcessingService {
  final AiCoreKernel kernel;

  MessageProcessingService(this.kernel);

  /// الرسمي API - كل Clients تستخدمه
  /// Input (UI/API/CLI/Test) -> Output (UI/API/CLI/Test)
  MessageResponse processMessage(MessageRequest request) {
    AILogger.kernel("Processing query: '\${request.query}' conv=\${request.conversationId}");

    final contextFuture = kernel.buildContextOnly(
      request.query,
      conversationId: request.conversationId,
    );

    final stream = kernel.process(
      request.query,
      conversationId: request.conversationId,
      promptTemplateId: request.promptTemplateId,
    ).map((token) {
      AILogger.ui("Stream token: \${token.length > 20 ? token.substring(0,20) : token}");
      return token;
    });

    return MessageResponse(stream: stream, contextFuture: contextFuture);
  }

  // Convenience for simple use
  Stream<String> process(String query, {String conversationId = "default"}) {
    return processMessage(MessageRequest(query: query, conversationId: conversationId)).stream;
  }
}
