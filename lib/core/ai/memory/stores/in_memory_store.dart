import '../memory.dart';
import '../index/trie.dart';
import '../cache/lru_cache.dart';

class InMemoryStore {
  final Map<String, Memory> _store = {};
  final Trie _trie = Trie();
  final Map<String, Set<String>> _inverted = {};
  final LruCache<String, Memory> _cache;

  InMemoryStore(): _cache = LruCache(100);

  List<String> _tokenize(String text) {
    return text.toLowerCase().split(RegExp(r'\W+')).where((s)=>s.isNotEmpty).toList();
  }

  Future<Memory> save(Memory m) async {
    _store[m.id] = m;
    _cache.put(m.id, m);
    for (var token in _tokenize(m.content)) {
      _trie.insert(token, m.id);
      _inverted.putIfAbsent(token, ()=> <String>{}).add(m.id);
    }
    return m;
  }

  Future<Memory?> getById(String id) async {
    var mem = _cache.get(id) ?? _store[id];
    if (mem != null) {
      mem.accessCount++;
      mem.lastAccess = DateTime.now();
      _cache.put(id, mem);
    }
    return mem;
  }

  Future<List<Memory>> search(String query) async {
    var tokens = _tokenize(query);
    if (tokens.isEmpty) return [];
    Set<String>? ids;
    for (var t in tokens) {
      var set = _inverted[t] ?? _trie.searchPrefix(t);
      if (ids == null) ids = Set.from(set);
      else ids = ids.intersection(set);
    }
    if (ids == null) return [];
    return ids.map((id)=>_store[id]!).where((m)=>_store.containsKey(m.id)).toList();
  }

  Future<void> delete(String id) async {
    var mem = _store.remove(id);
    _cache.remove(id);
    if (mem != null) {
      for (var token in _tokenize(mem.content)) {
        _trie.remove(token, id);
        _inverted[token]?.remove(id);
        if (_inverted[token]?.isEmpty ?? false) _inverted.remove(token);
      }
    }
  }

  int get count => _store.length;
  Iterable<Memory> get all => _store.values;
}
