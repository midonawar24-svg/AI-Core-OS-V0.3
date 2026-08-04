import 'dart:async';
class RuntimeState {
  final String status;
  const RuntimeState(this.status);
}
class FakeFllamaEngine {
  final List<String> responses;
  int _index = 0;
  const FakeFllamaEngine({this.responses = const ['fake response']});
  Future<String> generate(String prompt) async {
    if (_index >= responses.length) _index = 0;
    return responses[_index++];
  }
  Stream<String> stream(String prompt) async* {
    yield await generate(prompt);
  }
  Future<RuntimeState> getState() async {
    return const RuntimeState('idle');
  }
}
