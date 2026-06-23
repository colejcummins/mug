import Foundation

/// Shared identifiers used across the apps and their extensions.
///
/// The App Group lets the main app, the `DeviceActivityMonitor` extension and the
/// `ShieldConfiguration` extension read/write the same `UserDefaults` suite. You must
/// register this group in the Apple Developer portal and enable the **App Groups**
/// capability on each target before it works on device.
public enum MugIdentifiers {
    /// Reverse-DNS prefix for the whole project. Change this to your own domain.
    public static let bundlePrefix = "com.example.mug"

    /// Shared App Group identifier. Must match the entitlements files.
    public static let appGroup = "group.com.example.mug"

    /// Name used by `DeviceActivityCenter` to identify our monitoring schedule.
    public static let monitorActivityName = "com.example.mug.dailyMonitor"
}
