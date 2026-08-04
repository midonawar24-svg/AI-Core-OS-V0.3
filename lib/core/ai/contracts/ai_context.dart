import 'dart:collection';

enum ContextEntryType { system, conversation, memory, rag, plugin, userQuery }
enum ContextSource { memory, rag, plugin, conversation, system, user }

class ContextEntry {
  final String id;
  final ContextEntryType type;
  final ContextSource source;
  final String content;
  final double relevance;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  ContextEntry({
    required this.id,
    required this.type,
    required this.source,
    required this.content,
    this.relevance = 1.0,
    DateTime? timestamp,
    this.metadata = const {},
  }) : timestamp = timestamp ?? DateTime.now();
}

class AIContext {
  final String rawQuery;
  final String normalizedQuery;
  final String conversationId;
  final DateTime createdAt;
  final List<ContextEntry> entries;
  final Map<String, dynamic> extras;

  AIContext({
    required this.rawQuery,
    required this.conversationId,
    String? normalizedQuery,
    List<ContextEntry> entries = const [],
    Map<String, dynamic> extras = const {},
    DateTime? createdAt,
  })  : normalizedQuery = normalizedQuery ?? rawQuery.trim().toLowerCase(),
        createdAt = createdAt ?? DateTime.now(),
        entries = List.unmodifiable(entries),
        extras = Map.unmodifiable(extras);

  AIContext copyWith({List<ContextEntry>? entries, Map<String, dynamic>? extras}) {
    return AIContext(
      rawQuery: rawQuery,
      conversationId: conversationId,
      normalizedQuery: normalizedQuery,
      entries: entries ?? this.entries,
      extras: extras ?? this.extras,
      createdAt: createdAt,
    );
  }

  List<ContextEntry> getByType(ContextEntryType type) => entries.where((e) => e.type == type).toList();
}
