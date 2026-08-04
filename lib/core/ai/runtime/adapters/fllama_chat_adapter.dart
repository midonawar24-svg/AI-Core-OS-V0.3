class FllamaChatAdapter {
  const FllamaChatAdapter();

  String formatPrompt(String role, String content) {
    // fixed: interpolation instead of string + 
    return '$role: $content';
  }

  Future<void> send() async {
    const timeout = Duration(seconds: 30);
    await Future.delayed(timeout);
  }
}
