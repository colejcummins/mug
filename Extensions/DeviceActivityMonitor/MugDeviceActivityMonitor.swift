import DeviceActivity
import ManagedSettings

/// Runs in the background when a monitored interval starts/ends or a usage threshold is hit.
/// This is where a limit turns into an interruption: when an app/domain reaches its allowance
/// we add it to the shield, which makes iOS cover it with the block screen defined by the
/// `ShieldConfiguration` extension.
///
/// Requires the `com.apple.developer.family-controls` entitlement and the shared App Group.
final class MugDeviceActivityMonitor: DeviceActivityMonitor {
    private let store = ManagedSettingsStore()

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        // New day/interval: clear yesterday's shields so the user starts fresh.
        store.shield.applications = nil
        store.shield.webDomains = nil
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
    }

    override func eventDidReachThreshold(
        _ event: DeviceActivityEvent.Name,
        activity: DeviceActivityName
    ) {
        super.eventDidReachThreshold(event, activity: activity)
        // TODO: Map `event` back to the limit's tokens (persisted in the shared App Group) and
        // add those `ApplicationToken`s / `WebDomainToken`s to the shield, e.g.:
        //   store.shield.applications = tokensForEvent(event)
        // Until tokens are wired up this is a no-op placeholder.
    }
}
