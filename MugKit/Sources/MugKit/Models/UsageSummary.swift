import Foundation

/// A roll-up of time spent on one app or domain, optionally attributed to a specific device.
///
/// In the real Screen Time integration this is derived from `DeviceActivity` reports. Across
/// devices, summaries are reconciled by `iCloud` sync (a later milestone). For now the stub
/// service produces sample data so the UI has something to render.
public struct UsageSummary: Identifiable, Hashable, Sendable {
    public let id: UUID
    public var displayName: String
    /// Total time spent today, in seconds.
    public var duration: TimeInterval
    /// Originating device (e.g. "Cole's iPhone", "MacBook Pro"). `nil` = this device.
    public var deviceName: String?

    public init(
        id: UUID = UUID(),
        displayName: String,
        duration: TimeInterval,
        deviceName: String? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.duration = duration
        self.deviceName = deviceName
    }

    /// "1h 12m" / "8m" style label for the UI.
    public var formattedDuration: String {
        let minutes = Int(duration) / 60
        let hours = minutes / 60
        let remaining = minutes % 60
        if hours > 0 { return "\(hours)h \(remaining)m" }
        return "\(remaining)m"
    }
}
