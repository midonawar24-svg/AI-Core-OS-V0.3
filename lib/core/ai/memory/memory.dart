class Memory {
  final String id;
  final String content;
  DateTime lastAccess;
  int accessCount;
  final DateTime createdAt;
  Memory({required this.id, required this.content, DateTime? lastAccess, this.accessCount=0, DateTime? createdAt})
    : lastAccess = lastAccess ?? DateTime.now(),
      createdAt = createdAt ?? DateTime.now();
}

class MemoryStats {
  final int totalCount;
  MemoryStats(this.totalCount);
}
