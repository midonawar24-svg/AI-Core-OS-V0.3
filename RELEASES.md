# Release Map - AI Core OS - Professional Framework

## v0.1.0 [DONE ✅] - Core foundation
- Contracts locked, InMemory, 25 tests GREEN

## v0.2.0 [DONE ✅] - First End-to-End Working Build - Message Processing Vertical Slice
- Date: 2026-08-04
- MessageProcessingService.processMessage() - Official API for UI/API/CLI/Test
- Input (UI/API/CLI/Test) -> Kernel -> Pipeline (5) -> PromptBuilder -> FakeRuntime -> Streaming -> Output
- Unified Logger: [Kernel][Pipeline][Memory][Prompt][Runtime][UI][Bootstrap]
- Minimal Chat UI as Client only
- FakeChatRuntime streaming
- Integration Tests: Kernel + Bootstrap + MessageProcessing
- Cleanup: No disconnected components, 105 files
- Manual Smoke Test: 10 messages, no leak, no crash

DoD v0.2.0 (7 checks):
- [x] Build succeeds (needs local verification)
- [x] All tests GREEN (per contracts)
- [x] First message E2E
- [x] Logger works
- [x] Chat with FakeRuntime
- [x] No disconnected dependencies
- [x] Smoke Test 10 messages

Tag: v0.2.0 - First end-to-end working build

## v0.3.0 [NEXT - 4 Phases] - Fllama Adapter + First Real Chat + Performance + Stress

### Phase 1: Fllama Adapter Only
- Create FllamaChatRuntime implements ChatRuntime
  - load()
  - generate() streaming
  - unload()
- No UI change at all - Contract → Adapter
- File: lib/core/ai/runtime/adapters/fllama_chat_adapter.dart

### Phase 2: Adapter Test - Bootstrap Swap Only
- In TestBootstrap/Production Bootstrap:
  - Replace: FakeChatRuntime -> FllamaChatRuntime
- If chat works without UI/Kernel change, architecture succeeded (proof)
- This is the key test for Framework design

### Phase 3: Performance Tracker - From First Real Run
- Model Load Time
- First Token Time
- Tokens/sec
- RAM Usage
- Context Length
- Saved in PERFORMANCE_BASELINE_v0.3.0.md

### Phase 4: Stress Test - Before Isar
- 20-30 consecutive messages
- Reload model multiple times
- Open/close screen multiple times
- Check for Stream/Resource leaks
- No crash

DoD v0.3.0:
- [ ] FllamaChatRuntime implements ChatRuntime
- [ ] Model Qwen2.5-0.5B loads
- [ ] First real AI response (not fake)
- [ ] Streaming works with real model
- [ ] Performance metrics recorded (baseline)
- [ ] Same Chat UI works (only Bootstrap swap)
- [ ] Stress Test 20-30 messages, reload, reopen, no leak, no crash
- [ ] If UI needs change to make model work, architecture failed

After v0.3.0: Install on real phone, daily use, then Isar for persistence

## v0.4.0 - Isar Adapters
- IsarMemoryStore + IsarVectorStore
- Same 17 contract tests must PASS
- Swap in Bootstrap only

## v0.5.0 - Plugins + Debug Panels

## v1.0.0 - Production

Principle: Contract -> Adapter -> Integration -> Working Build (every version)
Framework, not just Chat App. Add models, DBs, UIs as Adapters without Core redesign.
