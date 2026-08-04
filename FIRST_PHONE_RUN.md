# First Phone Run - v0.3.0 - Goal: First Real Message from Qwen

## Goal
"تشغيل التطبيق على الهاتف والحصول على أول رسالة حقيقية من الذكاء الاصطناعي."
No new features before this succeeds.

## Architecture Status
- Code written ✅ - All layers done: Engine+Adapter, State Machine with Error, Capabilities, No if outside Bootstrap
- Code built and run on phone ❌ - Not verified yet (needs local flutter run)

## Should it work on phone?
Supposedly yes IF:
- Flutter project builds without errors
- Fllama added and configured correctly
- Model file in correct place
- File permissions (if needed) correct

But cannot confirm before first real Build.

## Steps - Stop at first failure, fix before next

### 1. Open Project
- Open in Android Studio or VS Code
- Project: /mnt/data/ai_core_os_project

### 2. flutter pub get
```bash
cd ai_core_os_project
flutter pub get
```
Expected: Success, fllama 0.4.0 fetched
If fails: Check Flutter version >=3.2.0

### 3. Fix Build Errors
```bash
flutter analyze
```
Expected: 0 issues or known acceptable warnings
Common fixes:
- If fllama not found: flutter pub get again
- If isar build_runner needed: not needed for v0.3.0 (we use InMemory, Isar prepared for v0.4.0)

### 4. Prepare Model File

#### Option A: Assets (for first test)
```bash
mkdir -p assets/models
# Download Qwen2.5-0.5B Q4_K_M ~350MB
# Place as assets/models/qwen2.5-0.5b-q4_k_m.gguf
```

#### Option B: Device Storage (recommended for real use)
- On phone, create /storage/emulated/0/Download/models/
- Push model via adb:
```bash
adb push qwen2.5-0.5b-q4_k_m.gguf /storage/emulated/0/Download/models/
```
- Update config: modelPath = "/storage/emulated/0/Download/models/qwen2.5-0.5b-q4_k_m.gguf"

For first run, use Option A with small model or useFake=true to test UI first.

### 5. Run App on Phone
```bash
flutter run --target=lib/main_v03.dart
# Or for v0.2.0 UI test first:
flutter run --target=lib/main_v02.dart
```

Expected:
- App installs
- UI opens: "AI Core OS v0.3.0 - Fllama Adapter"
- Status: Ready

If fails:
- Check device connected: flutter devices
- Check permissions: android/app/src/main/AndroidManifest.xml needs READ_EXTERNAL_STORAGE if using device storage

### 6. UI Opens Test (v0.2.0 Fake first)
- With useFake=true (default in main_v03.dart for safety):
  - Type "السلام عليكم"
  - Should see Fake streaming response
  - Logger shows [Kernel][Pipeline][Runtime] etc
  - This proves UI -> Kernel -> Pipeline -> Prompt -> Runtime path works

If this fails, fix before real model.

### 7. Load Model (Real)

Change in lib/main_v03.dart or production_bootstrap:
```dart
// From:
final config = AICoreConfig.fakeConfig();
// To:
final config = AICoreConfig.realConfig(modelPath: "assets/models/qwen2.5-0.5b-q4_k_m.gguf");
```

Or via config:
```dart
AICoreConfig.realConfig(modelPath: "/data/user/0/com.example.ai_core_os/app_flutter/models/qwen2.5-0.5b.gguf")
```

Then:
```bash
flutter run --target=lib/main_v03.dart
```

Watch logs:
```
[Bootstrap] ChatRuntime: FllamaChatRuntime - REAL
[FllamaEngine] loadModel() path=...
[Runtime] Loading model...
[PERF] Load: 1.80s
[Runtime] Model loaded
```

If fails at load:
- Check file exists
- Check RAM: 0.5B needs ~1GB RAM, ensure device has 4GB+
- Check logs for Error state (should go to Error, not stuck in Loading)

### 8. First Real Message

With model loaded (State = Loaded/Idle):

Type: "السلام عليكم"

Expected logs:
```
[Kernel] Processing query: 'السلام عليكم'
[Pipeline] 5 stages - Context built: X entries
[Prompt] Template=qwen2.5 - 256 chars
[FllamaChatRuntime] generate() -> Engine.generate()
[FllamaEngine] generate() prompt=... state=loaded
[Runtime] First token ... generating
[PERF] First Token: 342ms
[UI] Stream token: وعليكم...
[PERF] TPS: 15.1
[Runtime] Generation completed
[State] Transition: generating -> idle
```

UI: Assistant bubble streams real Qwen response word by word

### Success Criteria for First Phone Run

- [ ] flutter pub get success
- [ ] flutter analyze 0 errors (or known)
- [ ] App installs on phone
- [ ] UI opens
- [ ] With Fake: "السلام عليكم" -> Fake streaming works
- [ ] With Real: Model loads - State goes Uninitialized -> Loading -> Loaded (not stuck)
- [ ] With Real: "السلام عليكم" -> First real token from Qwen appears in same chat UI
- [ ] No if(Fake/Fllama) outside Bootstrap - verified by code search
- [ ] No crash on 5 messages

If any fails, stop and fix that step.

## After Success - Measure Immediately

Once first real message works:

1. Model Load Time: ___s (from logs)
2. First Token Time: ___ms
3. TPS: ___ tokens/sec
4. RAM: Check Android Studio Profiler or adb shell dumpsys meminfo

Save to performance/baseline_v0.3.0.md

Then start Isar (v0.4.0) for persistence.

## From This Moment

From moment app responds on phone with real model, project enters actual running phase.
After that, additions (Isar, Plugins, Debug Panels) are improvements over working system, not building blocks.

## Troubleshooting

### Model not found
- Check path in AILogger: [FllamaEngine] loadModel() path=...
- For assets, need to copy from assets to app dir first (fllama needs file path, not asset bundle)
  Add helper to copy asset to temp dir

### Out of Memory
- Use Q4_0 instead of Q4_K_M (smaller)
- Ensure device has 4GB+ RAM
- Close other apps

### Build fails with fllama
- Ensure NDK installed via Android Studio
- Check fllama docs for minSdkVersion

### Stuck in Loading
- Should NOT happen after Error state addition - should go to Error state
- If still stuck, check State Machine transition logs

## No New Features Rule

Until first phone run succeeds, NO new files, NO new features, NO refactoring unless required to make phone run work.
Only fixes for build/run.
