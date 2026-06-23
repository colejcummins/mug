import SwiftUI
import MugKit

@main
struct MugMacApp: App {
    // macOS uses the stub: the Family Controls / DeviceActivity stack is iOS-first and very
    // limited on the Mac. The Mac app's main job is cross-device viewing (via iCloud, later).
    @StateObject private var model = AppModel(screenTime: StubScreenTimeService())

    var body: some Scene {
        WindowGroup {
            MugRootView()
                .environmentObject(model)
                .frame(minWidth: 560, minHeight: 420)
        }
        .windowResizability(.contentMinSize)
    }
}
