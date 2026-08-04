# Phase 3 v0.3.0 - First Real Response + Performance + Baseline

## Goal: First real response from Qwen proves Core works with real model

## Step 1: First Real Response Only (Main Goal)
Path:
Chat UI
  ↓
Kernel
  ↓
Pipeline
  ↓
PromptBuilder
  ↓
RuntimeController
  ↓
FllamaChatRuntime (Adapter)
  ↓
FllamaEngine (Wrapper)
  ↓
Qwen2.5-0.5B (fllama package)

Test:
> Input: "السلام عليكم"
> Expected: First Token from Qwen in same chat UI (chat_page_v02.dart unchanged)
> If first token appears, Step 1 PASS

No performance yet, just prove it works.

## Step 2: Performance Tracker
After real response works, enable measurements:

- Model Load Time
- First Token Time
- Total Generation Time
- Tokens/sec
- Peak RAM (if measurable)
- Context Length
- Prompt Length

Logger output:
[PERF] Load: 2.18s
[PERF] First Token: 430ms
[PERF] TPS: 15.2
[PERF] Prompt Tokens: 286
[PERF] Total: 3.4s - 45 tokens

All via PerformanceTracker - no UI change

## Step 3: Baseline
Save first results in:

performance/
└── baseline_v0.3.0.md

So any future improvement is numeric comparison, not feeling.

## Bonus: RuntimeCapabilities

Instead of UI/Kernel assuming all Runtimes same, each Runtime declares:

class RuntimeCapabilities {
  bool supportsStreaming;
  bool supportsCancellation;
  bool supportsEmbeddings;
  bool supportsVision;
  int? maxContextLength;
}

chatRuntime.capabilities -> Core knows capabilities without if

Benefits when adding different models later:
- Qwen: maxContext 2048
- Llama3: maxContext 4096
- Vision model: supportsVision true
- Core adapts without if(Fake/Fllama)

## DoD Phase 3

- [ ] First real response appears (Step 1)
- [ ] Streaming works with real model
- [ ] Same Chat UI (no change)
- [ ] Performance recorded (Step 2)
  - [ ] Load Time
  - [ ] First Token
  - [ ] Total Time
  - [ ] TPS
  - [ ] Prompt/Context tokens
- [ ] Baseline saved in performance/baseline_v0.3.0.md (Step 3)
- [ ] RuntimeCapabilities added - Core uses capabilities, not if
- [ ] No file outside Bootstrap changed for model swap

After Phase 3:
v0.3.0 achieves main goal -> Move to v0.4.0 Isar for persistence, while Chat UI and Kernel remain same.

Project direction: Each version adds real operational capability, not just file count/complexity - keeps platform stable while growing.
