import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ai/kernel/ai_core_kernel.dart';
import '../../../../core/ai/bootstrap/ai_core_bootstrap.dart';
import '../../../../core/ai/config/ai_core_config.dart';
import '../../../../core/ai/bootstrap/test_bootstrap.dart';

final kernelProvider = FutureProvider<AiCoreKernel>((ref) async {
  // For v0.2.0 we use TestBootstrap (FakeRuntime)
  return TestBootstrap.buildForTest();
});

class ChatMessage {
  final String role; // user / assistant
  final String text;
  ChatMessage({required this.role, required this.text});
}

class ChatPageV02 extends ConsumerStatefulWidget {
  const ChatPageV02({super.key});
  @override ConsumerState<ChatPageV02> createState() => _ChatPageV02State();
}

class _ChatPageV02State extends ConsumerState<ChatPageV02> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isStreaming = false;
  String _status = "Ready";

  Future<void> _send() async {
    final query = _controller.text.trim();
    if (query.isEmpty || _isStreaming) return;

    setState(() {
      _messages.add(ChatMessage(role: "user", text: query));
      _isStreaming = true;
      _status = "Pipeline -> PromptBuilder -> Runtime";
    });
    _controller.clear();

    final kernelAsync = ref.read(kernelProvider);
    final kernel = await kernelAsync.when(data: (k) => Future.value(k), loading: () async => TestBootstrap.buildForTest(), error: (e,s) => TestBootstrap.buildForTest());

    // Build context for debug
    final ctx = await kernel.buildContextOnly(query);
    print("Pipeline built: \${ctx.entries.length} entries");

    final buffer = StringBuffer();
    setState(() {
      _messages.add(ChatMessage(role: "assistant", text: ""));
    });

    try {
      await for (final token in kernel.process(query)) {
        buffer.write(token);
        setState(() {
          _messages.last = ChatMessage(role: "assistant", text: buffer.toString());
        });
      }
      setState(() {
        _status = "Ready - \${ctx.entries.length} context entries";
        _isStreaming = false;
      });
    } catch (e) {
      setState(() {
        _status = "Error: \$e";
        _isStreaming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Core OS v0.2.0 - Minimal Chat"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(24),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(_status, style: TextStyle(fontSize: 12, color: Colors.greenAccent)),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (c,i) {
                final m = _messages[i];
                final isUser = m.role == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[800] : Colors.grey[850],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(m.text, style: TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          ),
          if (_isStreaming) LinearProgressIndicator(),
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: "اكتب: السلام عليكم",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton.filled(onPressed: _send, icon: Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
