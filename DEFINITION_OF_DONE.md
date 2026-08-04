# Definition of Done (DoD) - لكل Release

## v0.1.0 [DONE ✅]
- [x] Build ينجح
- [x] Contracts locked
- [x] InMemory + 25 tests GREEN
- [x] VERSION = v0.1.0

## v0.2.0 - Integration + Minimal Chat UI [FINAL CHECK]
- [ ] Build ينجح (flutter analyze)
- [ ] جميع الاختبارات خضراء (Contract + Unit + Integration)
  - [ ] Kernel Integration Test PASS
  - [ ] Bootstrap Integration Test PASS
  - [ ] MessageProcessingService Test PASS
- [ ] أول رسالة تمر End-to-End
  - Input (UI/API/CLI/Test) -> Kernel -> Pipeline (5) -> PromptBuilder -> FakeRuntime -> Streaming -> Output
- [ ] Logger يعمل [Kernel][Pipeline][Memory][Prompt][Runtime][UI][Bootstrap]
- [ ] Chat يعمل بالـ FakeRuntime (TextField + Send + Messages + Streaming + Status)
- [ ] لا توجد Dependencies أو Components غير موصلة
  - [ ] أي Service/Stage/Adapter موجود لازم يكون مستخدم فعلًا أو غير موجود
  - [ ] مفيش ملفات "للاستخدام لاحقًا" - كل حاجة متوصلة أو محذوفة
  - [ ] flutter analyze يطلع 0 unused imports
- [ ] Manual Smoke Test ناجح
  - [ ] شغل المشروع: flutter run --target=lib/main_v02.dart
  - [ ] ابعت 5-10 رسائل متتالية
  - [ ] Streaming شغال في كل رسالة
  - [ ] مفيش Memory Leak ظاهر (RAM مستقر)
  - [ ] مفيش Exceptions في الـ Logger
  - [ ] تقفل الشاشة وتفتحها تاني بدون Crash
  - [ ] Lifecycle: Ready -> Loading -> Ready في كل مرة

## v0.3.0 - Fllama + First Real Chat + Performance Baseline [NEXT]
Priority:
1. دمج Fllama Adapter
2. تحميل موديل Qwen2.5-0.5B
3. أول رد حقيقي من الذكاء الاصطناعي
4. تسجيل مقاييس الأداء (Load Time / First Token / TPS / RAM)
5. التأكد إن الشات الحالي يعمل بدون أي تعديل في الـ UI، فقط تبديل الـ Runtime في الـ Bootstrap
   - لو احتجت تغير الـ UI عشان الموديل يشتغل، يبقى فيه مشكلة في المعمارية

DoD v0.3.0:
- [ ] Fllama يحمل الموديل
- [ ] أول رد حقيقي يخرج
- [ ] Streaming يعمل
- [ ] قياسات الأداء تُسجل (Baseline in PERFORMANCE_BASELINE.md)
- [ ] لا يوجد Crash بعد 10 محادثات
- [ ] نفس Chat UI بدون تغيير (فقط Bootstrap swap: FakeRuntime -> FllamaChatRuntime)
- [ ] No disconnected components
- [ ] Manual Smoke Test: 10 messages real model, no leak, no crash

After v0.3.0: Install on real phone, daily use, then move to Isar for persistence

## v0.4.0 - Isar Adapters
- [ ] المحادثات تُحفظ في Isar
- [ ] البحث في الذاكرة يعمل
- [ ] VectorStore يعمل
- [ ] Contract Tests Isar كلها خضراء
- [ ] Same UI, only Bootstrap swap: InMemory -> Isar
- [ ] No disconnected components

## General Rules
1. أي مكون جديد يتوصل فورًا ويتجرب عمليًا قبل التالي
2. Working Build دائمًا
3. No dead code - كل ملف موجود مستخدم أو محذوف
4. Performance measured from v0.3.0
5. If UI needs change to make model work, architecture problem
