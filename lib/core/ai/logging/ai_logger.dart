enum LogLevel { debug, info, warning, error }

class AILogger {
  static bool enabled = true;
  static LogLevel minLevel = LogLevel.debug;

  static void _log(String tag, String message, LogLevel level) {
    if (!enabled) return;
    if (level.index < minLevel.index) return;

    final timestamp = DateTime.now().toIso8601String().split('T').last.split('.').first;
    final levelStr = level.toString().split('.').last.toUpperCase();
    print("[$timestamp][$levelStr][$tag] $message");
  }

  static void kernel(String msg) => _log("Kernel", msg, LogLevel.info);
  static void pipeline(String msg) => _log("Pipeline", msg, LogLevel.debug);
  static void memory(String msg) => _log("Memory", msg, LogLevel.debug);
  static void prompt(String msg) => _log("Prompt", msg, LogLevel.debug);
  static void runtime(String msg) => _log("Runtime", msg, LogLevel.info);
  static void ui(String msg) => _log("UI", msg, LogLevel.debug);
  static void bootstrap(String msg) => _log("Bootstrap", msg, LogLevel.info);
  static void error(String tag, String msg, [dynamic e]) => _log(tag, "$msg ${e ?? ''}", LogLevel.error);
}
