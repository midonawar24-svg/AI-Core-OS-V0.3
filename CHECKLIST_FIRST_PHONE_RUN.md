# Checklist - First Phone Run - Single Goal

## Goal
"تشغيل التطبيق على الهاتف والحصول على أول رسالة حقيقية من الذكاء الاصطناعي."

## Rule
لن نضيف أي مكونات جديدة قبل أن ننجح في ذلك.
Only fixes for build/run, no new features, no refactoring unless required for phone run.

## Steps - Stop at first failure

1. [ ] Open project in Android Studio / VS Code
   - Path: ai_core_os_project
   - File exists: pubspec.yaml with fllama dependency

2. [ ] flutter pub get
   - Command: flutter pub get
   - Expected: Success, fllama fetched
   - If fails: Check Flutter version, internet

3. [ ] Fix Build Errors
   - Command: flutter analyze
   - Expected: 0 errors
   - Fix any errors before next

4. [ ] Run on Phone (Fake first - safer)
   - Command: flutter run --target=lib/main_v02.dart
   - Expected: App installs, UI opens "AI Core OS v0.2.0"
   - If fails: Check flutter devices, USB debugging

5. [ ] UI Opens
   - Expected: TextField, Send button, Status Ready
   - No crash

6. [ ] Fake Test - 5 messages
   - Type "السلام عليكم" -> Fake streaming works
   - 5 messages consecutive -> No crash, no leak
   - Logger shows [Kernel][Pipeline][Runtime]

7. [ ] Load Model (Real)
   - Change config to realConfig()
   - Model file placed correctly
   - Logs: [Runtime] Loading model... -> [Runtime] Model loaded
   - State: Uninitialized -> Loading -> Loaded (not stuck)
   - If fails: Should go to Error state, not stuck

8. [ ] First Real Message
   - Type "السلام عليكم"
   - Expected: First token from Qwen appears in same chat UI
   - Logs: First Token 342ms, TPS 15.1
   - Same UI, same Kernel, only Bootstrap changed

## After Success

- [ ] Measure: Load Time, First Token, TPS, RAM
- [ ] Save to performance/baseline_v0.3.0.md
- [ ] Then start Isar v0.4.0

## From This Moment

From moment app responds on phone with real model, project enters actual running phase.
After that, Isar, Plugins, Debug Panels are improvements over working system.

## Current Status

- Code written: ✅ (Engine+Adapter, State Machine with Error, Capabilities, No if outside Bootstrap)
- Code built and run on phone: ❌ (Needs local verification - this checklist)
- First real Qwen message: ❌ (Depends on phone run)

Next action: Run checklist locally, step by step, stop at first failure.
