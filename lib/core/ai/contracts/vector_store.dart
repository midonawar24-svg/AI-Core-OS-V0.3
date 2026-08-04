class VectorRecord {
  final String id;
  final List<double> vector;
  final Map<String, dynamic> metadata;
  VectorRecord({required this.id, required this.vector, this.metadata = const {}});
}

class VectorSearchResult {
  final String id;
  final double score;
  VectorSearchResult({required this.id, required this.score});
}

abstract class VectorTransaction {
  void save(VectorRecord record);
  void saveAll(List<VectorRecord> records);
  Future<void> commit();
  Future<void> rollback();
}

abstract class VectorStore {
  Future<VectorTransaction> beginTransaction();
  Future<void> save(VectorRecord record);
  Future<List<VectorSearchResult>> search(List<double> queryVector, {int topK = 5});
  Future<void> delete(String id);
}

abstract class MemoryTransaction {
  void save(MemoryRecord record);
  void saveAll(List<MemoryRecord> records);
  Future<void> commit();
  Future<void> rollback();
}

abstract class MemoryStore {
  Future<MemoryTransaction> beginTransaction();
  Future<void> save(MemoryRecord record);
  Future<MemoryRecord?> getById(String id);
  Future<List<MemoryRecord>> getByIds(List<String> ids);
  Future<void> delete(String id);
}
