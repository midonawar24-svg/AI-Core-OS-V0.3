import '../../contracts/ai_context.dart';
abstract class PromptTemplate { String format({required AIContext context}); }

class Qwen25Template implements PromptTemplate {
  @override String format({required AIContext context}) {
    final ctx = context.entries.map((e)=> "[${e.source.name}]: ${e.content}").join("\n");
    return "<|im_start|>system\n$ctx<|im_end|>\n<|im_start|>user\n${context.rawQuery}<|im_end|>\n<|im_start|>assistant\n";
  }
}

class Llama3Template implements PromptTemplate {
  @override String format({required AIContext context}) {
    final ctx = context.entries.map((e)=> e.content).join("\n");
    return "<|begin_of_text|><|start_header_id|>system<|end_header_id|>\n$ctx<|eot_id|><|start_header_id|>user<|end_header_id|>\n${context.rawQuery}<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n";
  }
}

class TemplateRegistry {
  final Map<String, PromptTemplate> _templates = {};
  void register(String id, PromptTemplate t) => _templates[id]=t;
  PromptTemplate resolve(String id) => _templates[id] ?? _templates["qwen2.5"]!;
}
