# AI Core OS - v1.1 Stable
Memory Engine stabilization.

## Structure
lib/core/ai/memory/
- memory_engine.dart (core API)
- stores/in_memory_store.dart
- index/trie.dart
- cache/lru_cache.dart
- utils/async_lock.dart

## CI
- analyze must pass without excludes
- test skips if test/ missing, runs if present

## First Tests
test/core/ai/memory/memory_engine_test.dart covers 8 scenarios
