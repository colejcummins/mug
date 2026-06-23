#if os(iOS)
import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

/// The real Screen Time integration. iOS-only — `FamilyControls`, `DeviceActivity` and
/// `ManagedSettings` are not available (or are heavily reduced) on macOS.
///
/// IMPORTANT: This compiles, but will only *run* once the project has the
/// `com.apple.developer.family-controls` entitlement (requested from Apple) and the user has
/// approved access. Several pieces are intentionally left as TODOs because they depend on the
/// opaque `FamilyActivitySelection` tokens the user picks via `FamilyActivityPicker` in the UI.
public final class LiveScreenTimeService: ScreenTimeControlling, @unchecked Sendable {
    private let center = DeviceActivityCenter()
    private let store = ManagedSettingsStore()

    public init() {}

    public var authorizationState: ScreenTimeAuthorizationState {
        switch AuthorizationCenter.shared.authorizationStatus {
        case .approved: return .approved
        case .denied: return .denied
        case .notDetermined: return .notDetermined
        @unknown default: return .notDetermined
        }
    }

    public func requestAuthorization() async throws {
        // `.individual` lets a person manage their own device without a parent/child pairing.
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }

    public func currentUsage() async -> [UsageSummary] {
        // Real usage numbers come from a `DeviceActivityReport` SwiftUI view backed by a
        // report extension; the values are privacy-opaque and cannot be read as plain numbers
        // here. This is a scaffold placeholder.
        // TODO: Host a `DeviceActivityReport` and surface its totals.
        []
    }

    public func startMonitoring(_ limits: [AppLimit]) throws {
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )
        // TODO: Build a `[DeviceActivityEvent.Name: DeviceActivityEvent]` from `limits`,
        // decoding each limit's `selectionData` into a `FamilyActivitySelection` and using its
        // `applicationTokens` / `webDomainTokens` with `threshold:` set to the daily limit.
        // The `DeviceActivityMonitor` extension applies the shield when a threshold is reached.
        try center.startMonitoring(
            DeviceActivityName(MugIdentifiers.monitorActivityName),
            during: schedule
        )
    }

    public func stopMonitoring() {
        center.stopMonitoring()
        store.shield.applications = nil
        store.shield.webDomains = nil
    }
}
#endif
