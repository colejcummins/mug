import SwiftUI
import MugKit

@main
struct MugiOSApp: App {
    // Swap `StubScreenTimeService()` for `LiveScreenTimeService()` once the Family Controls
    // entitlement is approved and you want real monitoring/shielding.
    @StateObject private var model = AppModel(screenTime: StubScreenTimeService())

    var body: some Scene {
        WindowGroup {
            MugRootView()
                .environmentObject(model)
        }
    }
}
