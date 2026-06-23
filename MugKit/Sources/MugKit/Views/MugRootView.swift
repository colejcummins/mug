import SwiftUI

/// Entry view shared by both apps. Uses a tab bar on iOS and a sidebar split view on macOS,
/// but the screens themselves are identical.
public struct MugRootView: View {
    public init() {}

    public var body: some View {
        #if os(iOS)
        TabView {
            NavigationStack { DashboardView() }
                .tabItem { Label("Activity", systemImage: "chart.bar.fill") }
            NavigationStack { LimitsView() }
                .tabItem { Label("Limits", systemImage: "timer") }
        }
        #else
        MacRootView()
        #endif
    }
}

#if os(macOS)
private struct MacRootView: View {
    private enum Section: String, CaseIterable, Identifiable {
        case activity = "Activity"
        case limits = "Limits"
        var id: String { rawValue }
        var systemImage: String {
            switch self {
            case .activity: return "chart.bar.fill"
            case .limits: return "timer"
            }
        }
    }

    @State private var selection: Section? = .activity

    var body: some View {
        NavigationSplitView {
            List(Section.allCases, selection: $selection) { section in
                Label(section.rawValue, systemImage: section.systemImage)
                    .tag(section)
            }
            .navigationSplitViewColumnWidth(min: 160, ideal: 180)
        } detail: {
            switch selection {
            case .activity, .none: DashboardView()
            case .limits: LimitsView()
            }
        }
    }
}
#endif
