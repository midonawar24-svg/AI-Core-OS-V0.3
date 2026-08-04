# Phase 2 v0.3.0 - Bootstrap Swap Only - Architecture Test

## Critical Success Condition
> لا تسمح بأي if (FakeRuntime) أو if (FllamaRuntime) خارج الـ Bootstrap.

الاختيار بين Runtime يتم مرة واحدة فقط عند بناء النظام، وبعدها باقي المشروع ميعرفش هو شغال على Fake ولا Fllama.

## Implementation

### ONLY in Bootstrap
```dart
// lib/core/ai/bootstrap/production_bootstrap.dart - ONLY file with if
final ChatRuntime chatRuntime = config.useFakeRuntime
    ? FakeChatRuntime()
    : FllamaChatRuntime(FllamaEngine());

// After this, rest uses ChatRuntime contract only
final kernel = AiCoreBootstrap(config: config).build();
```

### Outside Bootstrap - NO if
- Chat UI: uses kernel.processMessage() - no type check
- MessageProcessing: uses ChatRuntime contract - no type check
- Kernel: uses RuntimeController.chatRuntime - no type check
- RuntimeController: uses ChatRuntime - no type check
- PromptBuilder: no runtime knowledge

## DoD Phase 2

- [ ] Bootstrap فقط هو اللي اتغير (production_bootstrap.dart)
- [ ] أول رد حقيقي من Qwen يظهر في نفس واجهة الشات (نفس chat_page_v02.dart بدون تعديل)
- [ ] Logger يسجل:
  [Runtime] Loading model...
  [Runtime] Model loaded
  [Runtime] First token ...
  [Runtime] Generation completed
- [ ] State Machine تنتقل:
  Uninitialized -> Loading -> Loaded -> Generating -> Idle -> Error (if fails)
- [ ] لو استدعيت generate() قبل load() ترجع StateError واضحة
  "Cannot generate in state uninitialized - Model not loaded. Did you call load() first?"
- [ ] لو فشل تحميل الموديل، ترجع الحالة إلى Error، ولا يظل عالقًا في Loading
  - Test: loadModel("invalid/path") -> State = Error, not Loading
  - Can retry: loadModel(validPath) from Error state

## State Machine with Error

Uninitialized
  ↓
Loading -> (on fail) -> Error (not stuck in Loading)
  ↓ (on success)
Loaded
  ↓
Generating
  ↓
Idle
  ↓
Error (on fail) -> can retry load()
  ↓
Unloading -> Disposed

Benefits of Error state:
- Show message in UI: "Model failed to load: file not found"
- Retry button
- Log errors
- No unknown state after failure

## Architecture Proof

If Phase 2 succeeds without modifying any file outside Bootstrap, it's strongest practical proof:
- Core is properly isolated
- Contract -> Adapter -> Integration -> Working Build is real, not just paper design

After this, next goal: first real response from Qwen with performance numbers, then Isar.

## Verification

Search project for if(Fake) or if(Fllama) outside Bootstrap:
```bash
grep -r "FakeChatRuntime\|FllamaChatRuntime\|is Fake\|is Fllama" lib/ --exclude-dir=bootstrap
# Expected: 0 results outside bootstrap/
```

Search for runtime type checks:
```bash
grep -r "runtimeType ==\|is FllamaEngine" lib/features lib/core/ai/kernel lib/core/ai/context
# Expected: 0 results
```
