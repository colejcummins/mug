import Foundation
import SwiftUI

/// Top-level observable state injected into the SwiftUI environment by each app target.
/// The views read everything from here; the app targets decide which `ScreenTimeControlling`
/// implementation to inject (stub vs. live).
@MainActor
public final class AppModel: ObservableObject {
    public let limits: LimitStore
    public let screenTime: any ScreenTimeControlling

    @Published public private(set) var summaries: [UsageSummary] = []
    @Published public private(set) var authorizationState: ScreenTimeAuthorizationState

    public init(
        screenTime: any ScreenTimeControlling = StubScreenTimeService(),
        limits: LimitStore? = nil
    ) {
        self.screenTime = screenTime
        self.limits = limits ?? LimitStore()
        self.authorizationState = screenTime.authorizationState
    }

    public func refresh() async {
        summaries = await screenTime.currentUsage()
        authorizationState = screenTime.authorizationState
    }

    public func requestAuthorization() async {
        try? await screenTime.requestAuthorization()
        authorizationState = screenTime.authorizationState
    }

    /// Total tracked time across all summaries, formatted for the dashboard header.
    public var totalFormatted: String {
        let total = summaries.reduce(0) { $0 + $1.duration }
        let minutes = Int(total) / 60
        let hours = minutes / 60
        let remaining = minutes % 60
        return hours > 0 ? "\(hours)h \(remaining)m" : "\(remaining)m"
    }
}
