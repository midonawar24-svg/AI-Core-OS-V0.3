class LruCache<K,V> {
  final int capacity;
  final Map<K,V> _map = {};
  final List<K> _order = [];
  LruCache(this.capacity);
  V? get(K key) {
    if (!_map.containsKey(key)) return null;
    _order.remove(key);
    _order.add(key);
    return _map[key];
  }
  void put(K key, V value) {
    if (_map.containsKey(key)) {
      _order.remove(key);
    } else if (_map.length >= capacity) {
      var lru = _order.removeAt(0);
      _map.remove(lru);
    }
    _map[key] = value;
    _order.add(key);
  }
  void remove(K key) {
    _map.remove(key);
    _order.remove(key);
  }
}
