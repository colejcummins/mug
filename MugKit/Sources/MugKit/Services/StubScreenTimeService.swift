import Foundation

/// A dependency-free implementation used on macOS, in tests, in SwiftUI previews, and on iOS
/// before the Family Controls entitlement is granted. It returns sample data so the whole UI
/// can be built and demoed without any system permissions.
public final class StubScreenTimeService: ScreenTimeControlling, @unchecked Sendable {
    public private(set) var authorizationState: ScreenTimeAuthorizationState

    public init(authorizationState: ScreenTimeAuthorizationState = .notDetermined) {
        self.authorizationState = authorizationState
    }

    public func requestAuthorization() async throws {
        authorizationState = .approved
    }

    public func currentUsage() async -> [UsageSummary] {
        [
            UsageSummary(displayName: "Safari", duration: 72 * 60, deviceName: "iPhone"),
            UsageSummary(displayName: "Messages", duration: 41 * 60, deviceName: "iPhone"),
            UsageSummary(displayName: "Xcode", duration: 188 * 60, deviceName: "MacBook Pro"),
            UsageSummary(displayName: "youtube.com", duration: 53 * 60, deviceName: "MacBook Pro"),
        ]
    }

    public func startMonitoring(_ limits: [AppLimit]) throws {
        // No-op: the stub does not enforce limits.
    }

    public func stopMonitoring() {
        // No-op.
    }
}
