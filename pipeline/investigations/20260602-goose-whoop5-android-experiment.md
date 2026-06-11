---
date: 2026-06-02
topic: "Look into this\n\nhttps://github.com/b-nnett/goose\n\nI have a whoop 5..."
discord_message_id: "1511433179670642910"
status: complete
---

# Goose: Local WHOOP 5.0 Companion — Android Experiment Scoping

## Topic
Investigate `github.com/b-nnett/goose` — a local-first WHOOP 5.0 companion app. The user has a WHOOP 5 and wants to continue using it after subscription ends via a personal Android app with PC sync. Create an experiment project. Archive the repo in case it goes down.

## Key Findings

- **Goose is iOS/Swift only** (as of June 2, 2026, the repo's creation date). No Android port exists. The repo is brand new with 657 stars already — high signal.
- **Architecture is split**: SwiftUI frontend + Rust core. The **Rust core** (`Rust/core`) handles BLE packet parsing, health algorithms, and data storage — this is the cross-platform path to Android.
- **Rust → Android is viable** via JNI/Kotlin FFI (`jnilibs`). The same Rust core that builds to a static `.a` for iOS can build to a `.so` for Android. BLE data capture would need new Kotlin code using Android's BLE APIs.
- **Public beta: June 13, 2026** (TestFlight, iOS only). The codebase is explicitly alpha/developer-only right now.
- **Local-first by design**: no WHOOP subscription required after initial BLE sync. The app reads data directly from the WHOOP 5.0 band over Bluetooth — this is exactly the post-subscription use case.
- **PC sync** is not implemented in Goose yet. The local-first Rust core could expose an HTTP or gRPC interface for sync to a desktop companion.
- **Repo download blocked**: `git clone` was denied by auto-mode during this run. Manual clone command documented below.

## Details

### What Goose Actually Does

Goose reverse-engineers (or legally re-implements, per their disclaimer) the WHOOP 5.0 BLE protocol. It:
1. Scans for the WHOOP 5.0 device via CoreBluetooth
2. Receives raw packet data
3. Passes JSON through a C bridge into the Rust core
4. Rust core parses packets, runs health algorithms (recovery score, HRV, sleep, strain, stress, SpO2, skin temp)
5. SwiftUI app displays the results in dashboards

The Rust core is committed in `Rust/core` and built via `Scripts/build_ios_rust.sh` into a static library. The bridge is in `GooseRustBridge.swift`.

### Android Path

The most viable Android approach:
1. **Reuse the Rust core** — add Android targets (`aarch64-linux-android`, `armv7-linux-androideabi`, `x86_64-linux-android`) via `rustup`, build with `cargo-ndk` or the NDK toolchain, produce `.so` files
2. **Write a Kotlin BLE layer** — Android BLE (BluetoothGatt) has different APIs than CoreBluetooth but serves the same purpose: scan, connect, read characteristics, receive notifications
3. **Write a Jetpack Compose UI** — health dashboards modeled after the SwiftUI equivalents in the Goose source
4. **Add PC sync** — expose a local REST/gRPC endpoint from the Rust core (it already has a Codex coach server in `docs/goose-swift-mvp/CodexCoachServer.md`), sync to a desktop Rust daemon

The hardest part is the BLE packet protocol — Goose has already done the reverse-engineering work in the Rust core, so if we can reuse that, the Android project is primarily a UI/BLE-transport problem.

### Post-Subscription Viability

WHOOP's subscription primarily gates access to their cloud dashboards and recommendations. The **band itself** stores data locally and exposes it over BLE. Goose's approach — reading directly from the band — is subscription-independent. This is the correct architecture for continued post-subscription use.

### PC Sync Architecture Sketch

```
WHOOP 5 band
     ↓ BLE
Android app (Kotlin + Rust core)
     ↓ local SQLite / HTTP API
Desktop daemon (Rust) on requiem
     ↓
Web dashboard or CLI
```

The Rust core already provides the algorithmic layer; the sync piece would be a small HTTP server in the Android app (or a sync-on-connect push to requiem via Tailscale).

## Relevance to Workspace

- **Experiment project**: `experiments/whoop-goose-android/` created. Awaiting manual clone of upstream (see below).
- **Rust toolchain**: requiem already has Rust/Cargo. Android NDK needed (`cargo-ndk`).
- **Tailscale sync**: requiem ↔ dashi (Android) are already on the same Tailscale mesh — ideal for local sync without cloud.
- **Timeline**: iOS beta drops June 13, 2026. Worth watching their BLE protocol documentation that may surface around then.

## Recommended Actions

1. **Manual clone** (git clone blocked by auto-mode this run):
   ```bash
   cd /home/<user>/claudeworkspace/experiments/whoop-goose-android
   gh repo clone b-nnett/goose goose-upstream
   ```
2. **Monitor June 13 TestFlight beta** — the BLE protocol documentation may be clearer after beta, and community PRs may begin porting the Rust targets.
3. **Audit the Rust core** (`goose-upstream/Rust/core/`) for Android FFI compatibility — specifically: does it use any Apple/iOS-only Rust crates, or is it platform-agnostic?
4. **Scaffold Android project skeleton** in `experiments/whoop-goose-android/android/` — Kotlin + Jetpack Compose + room for JNI integration.
5. **Check `docs/goose-swift-mvp/CodexCoachServer.md`** for the planned HTTP server API — this is directly relevant to PC sync design.
