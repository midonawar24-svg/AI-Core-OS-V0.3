import 'dart:math';
import 'memory.dart';
import 'stores/in_memory_store.dart';
import 'utils/async_lock.dart';

class MemoryEngine {
  final InMemoryStore store;
  final AsyncLock _lock = AsyncLock();
  MemoryEngine({required this.store});

  Future<Memory> remember({required String content}) {
    return _lock.synchronized(() async {
      var id = Random().nextInt(1<<32).toString();
      var mem = Memory(id: id, content: content);
      return await store.save(mem);
    });
  }

  Future<Memory?> getById(String id) => _lock.synchronized(()=>store.getById(id));
  Future<List<Memory>> search(String query) => _lock.synchronized(()=>store.search(query));
  Future<void> forget(String id) => _lock.synchronized(()=>store.delete(id));
  Future<MemoryStats> stats() => _lock.synchronized(() async => MemoryStats(store.count));
}
