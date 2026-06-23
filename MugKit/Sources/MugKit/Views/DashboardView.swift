import SwiftUI

/// Today's activity across the user's devices. Reads sample data from the stub service until
/// the live Screen Time integration is wired up.
public struct DashboardView: View {
    @EnvironmentObject private var model: AppModel

    public init() {}

    public var body: some View {
        List {
            Section {
                HStack {
                    Text("Today")
                        .font(.headline)
                    Spacer()
                    Text(model.totalFormatted)
                        .font(.headline)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
            }

            Section("By app") {
                if model.summaries.isEmpty {
                    Text("No activity yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(model.summaries) { summary in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(summary.displayName)
                                if let device = summary.deviceName {
                                    Text(device)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            Text(summary.formattedDuration)
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Activity")
        .task { await model.refresh() }
        .refreshable { await model.refresh() }
    }
}
