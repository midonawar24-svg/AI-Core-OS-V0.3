// AI Core OS - Runtime Events v1.1
sealed class RuntimeEvent {
  const RuntimeEvent();
}

class ModelLoading extends RuntimeEvent {
  const ModelLoading();
}

class ModelLoaded extends RuntimeEvent {
  const ModelLoaded();
}

class RuntimeReady extends RuntimeEvent {
  const RuntimeReady();
}

class ModelFailed extends RuntimeEvent {
  final String error;
  const ModelFailed(this.error);
}
