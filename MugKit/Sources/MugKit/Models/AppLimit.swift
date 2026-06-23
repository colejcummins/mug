import Foundation

/// A user-defined daily time limit for an app or a web domain.
///
/// Note: Apple's Screen Time API represents picked apps/domains as opaque, privacy-preserving
/// *tokens* (`ApplicationToken` / `WebDomainToken`) — not as plain strings. Those tokens live
/// inside a `FamilyActivitySelection` on iOS and cannot be inspected. So this cross-platform
/// model stores a human-readable `displayName` for the UI plus an optional serialized token
/// blob that the iOS layer knows how to decode. The Mac app and tests only ever touch the
/// plain fields.
public struct AppLimit: Identifiable, Codable, Hashable, Sendable {
    public enum Kind: String, Codable, Sendable {
        case app
        case webDomain
    }

    public let id: UUID
    public var displayName: String
    public var kind: Kind
    /// Allowed time per day, in minutes.
    public var dailyLimitMinutes: Int
    public var isEnabled: Bool
    /// Opaque, platform-specific selection data (e.g. an encoded `FamilyActivitySelection`).
    /// `nil` until the user has picked something via the system picker on iOS.
    public var selectionData: Data?

    public init(
        id: UUID = UUID(),
        displayName: String,
        kind: Kind = .app,
        dailyLimitMinutes: Int = 30,
        isEnabled: Bool = true,
        selectionData: Data? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.kind = kind
        self.dailyLimitMinutes = dailyLimitMinutes
        self.isEnabled = isEnabled
        self.selectionData = selectionData
    }

    public var dailyLimit: TimeInterval { TimeInterval(dailyLimitMinutes * 60) }
}
