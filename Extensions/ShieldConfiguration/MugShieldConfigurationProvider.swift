import ManagedSettings
import ManagedSettingsUI
import SwiftUI

/// Defines the screen iOS shows over an app or web page once its limit is reached — the
/// "interruption". Kept deliberately plain to match the app's minimal aesthetic.
///
/// Requires the `com.apple.developer.family-controls` entitlement.
final class MugShieldConfigurationProvider: ShieldConfigurationDataSource {
    private var configuration: ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .systemMaterial,
            title: ShieldConfiguration.Label(text: "Time's up", color: .label),
            subtitle: ShieldConfiguration.Label(
                text: "You've reached your limit for today.",
                color: .secondaryLabel
            ),
            primaryButtonLabel: ShieldConfiguration.Label(text: "OK", color: .white),
            primaryButtonBackgroundColor: .label
        )
    }

    override func configuration(shielding application: Application) -> ShieldConfiguration {
        configuration
    }

    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        configuration
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        configuration
    }

    override func configuration(
        shielding webDomain: WebDomain,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        configuration
    }
}
