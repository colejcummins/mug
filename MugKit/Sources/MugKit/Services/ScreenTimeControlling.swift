import Foundation

/// Whether the user has granted Screen Time (Family Controls) access.
public enum ScreenTimeAuthorizationState: Sendable {
    case notDetermined
    case denied
    case approved
}

/// The seam between the UI and Apple's Screen Time stack.
///
/// Everything the app needs from `FamilyControls` / `DeviceActivity` / `ManagedSettings`
/// is expressed here so the rest of the app (and the Mac target, and the tests) never
/// imports those iOS-only frameworks directly. Swap `StubScreenTimeService` for
/// `LiveScreenTimeService` once the Family Controls entitlement is approved.
public protocol ScreenTimeControlling: Sendable {
    /// Current authorization state, observed synchronously.
    var authorizationState: ScreenTimeAuthorizationState { get }

    /// Prompts the user for Screen Time access (no-op if already approved).
    func requestAuthorization() async throws

    /// Today's usage roll-up for this device.
    func currentUsage() async -> [UsageSummary]

    /// Begins watching the given limits and shields apps/domains that exceed them.
    func startMonitoring(_ limits: [AppLimit]) throws

    /// Stops all monitoring and removes any active shields.
    func stopMonitoring()
}
