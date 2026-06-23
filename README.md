# Mug

Minimal activity tracker for iOS and macOS. Tracks how long you spend in apps and on web
domains across your devices, and lets you set daily time limits that **interrupt** you (a block
screen) when you go over.

> Status: **scaffold only.** The structure, targets, shared code, and Screen Time integration
> points are in place. No real tracking/enforcement is wired up yet — the apps currently show
> sample data from a stub service.

## Requirements

- **Xcode 16 or newer** (the project uses file-system-synchronized groups, an Xcode 16 format).
  Full Xcode is required — Command Line Tools alone can't build app/extension targets.
- A paid Apple Developer account *eventually*, because the core feature needs the
  **Family Controls** entitlement (see below).

## Getting started

1. Open `Mug.xcodeproj` in Xcode.
2. Pick a scheme (Xcode auto-creates **MugiOS** and **MugMac** on first open) and Run.
   Both apps build and run immediately against the stub data — no entitlement needed yet.

## Project layout

```
Mug.xcodeproj/          Hand-written project. Four targets:
                          • MugiOS                 — iOS app
                          • MugMac                 — macOS app
                          • DeviceActivityMonitor  — iOS extension (watches limits, applies shields)
                          • ShieldConfiguration    — iOS extension (the block screen)

MugKit/                 Local Swift package — ALL shared code lives here:
  Sources/MugKit/
    Models/               AppLimit, UsageSummary
    Services/             ScreenTimeControlling (protocol), StubScreenTimeService,
                          LiveScreenTimeService (iOS-only), LimitStore, AppModel
    Views/                MugRootView, DashboardView, LimitsView, MugTheme
  Tests/MugKitTests/

MugiOS/                 Thin iOS app shell (@main) + Assets + entitlements
MugMac/                 Thin macOS app shell (@main) + Assets + entitlements
Extensions/             The two iOS app extensions + their Info.plist / entitlements
```

The apps are deliberately tiny: each is just a `@main` `App` that injects an `AppModel` and shows
`MugRootView()`. Everything else is shared through `MugKit`, so iOS and macOS stay in lock-step.

## How the Screen Time integration is meant to work

Apple's native stack is richer than just "Safari limits". Three frameworks cooperate:

- **FamilyControls** — asks the user for permission; provides the `FamilyActivityPicker` to choose
  apps / categories / web domains. Picked items are *opaque tokens*, not readable strings.
- **DeviceActivity** — schedules monitoring and fires a callback when a usage *threshold* is hit.
  That callback lives in the **DeviceActivityMonitor** extension.
- **ManagedSettings** — `shield`s (blocks) apps/domains. The **ShieldConfiguration** extension
  customizes the block screen the user sees — this is the "interruption".

In code, the app only ever talks to the `ScreenTimeControlling` protocol. Today that's
`StubScreenTimeService` (sample data, no permissions). `LiveScreenTimeService` is the real
implementation and compiles, but is iOS-only and won't *run* until the entitlement below is in place.
The `// TODO` markers in `LiveScreenTimeService` and `MugDeviceActivityMonitor` are where the
opaque token wiring still needs to happen.

## Before real tracking works (the hard requirements)

1. **Family Controls entitlement** (`com.apple.developer.family-controls`). This must be requested
   from Apple and enabled on the iOS app + both extensions. The `.entitlements` files already
   declare it. Without approval, authorization calls fail.
2. **App Group** (`group.com.example.mug`) so the app and extensions share storage. Register it in
   the developer portal and enable the App Groups capability on all three targets.
3. Change the placeholder bundle IDs (`com.example.mug*`) and the App Group ID to your own — they
   live in the target build settings, the `.entitlements` files, and `MugKit/.../MugIdentifiers.swift`.

## Known platform realities

- **macOS** support for Family Controls / DeviceActivity is far thinner than iOS. The Mac app uses
  the stub and is intended mainly for cross-device viewing (via iCloud, a later milestone). On-device
  enforcement is iOS-first.
- Usage data is **privacy-opaque**: you get tokens you render as labels, not raw per-app numbers you
  can freely export/aggregate.
- **Chrome** (stretch goal): system web-domain shielding covers Safari/WebKit, *not* Chrome's own
  network stack. Tracking/limiting Chrome realistically needs a companion Chrome extension that
  reports to the app — not yet scaffolded.

## Not yet built (intentionally)

- iCloud / CloudKit sync of limits and usage across devices.
- The `FamilyActivityPicker` flow that turns "New limit" into a real app/domain selection.
- Real usage numbers (requires a `DeviceActivityReport` view + report extension).
- Chrome companion extension.
