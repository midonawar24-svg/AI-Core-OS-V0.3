// AI Core OS - Runtime State v1.1
class RuntimeState {
  final String status;
  final bool isReady;
  const RuntimeState({this.status = 'idle', this.isReady = false});
  const RuntimeState.idle() : status = 'idle', isReady = false;
  const RuntimeState.loading() : status = 'loading', isReady = false;
  const RuntimeState.ready() : status = 'ready', isReady = true;
  const RuntimeState.failed() : status = 'failed', isReady = false;
}
