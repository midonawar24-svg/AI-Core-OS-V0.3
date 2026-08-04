// Runtime capabilities for AI Core OS
class RuntimeCapabilities {
  final bool supportsStreaming;
  final bool supportsVision;
  const RuntimeCapabilities({
    this.supportsStreaming = true,
    this.supportsVision = false,
  });
}
