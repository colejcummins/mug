import SwiftUI

/// Lists the user's limits and lets them toggle, adjust, add and remove them.
///
/// On iOS, "Add limit" should eventually present a `FamilyActivityPicker` to choose real apps
/// or web domains; for now it appends a placeholder so the flow is visible everywhere.
public struct LimitsView: View {
    @EnvironmentObject private var model: AppModel

    public init() {}

    public var body: some View {
        List {
            if model.limits.limits.isEmpty {
                Text("No limits set. Add one to start enforcing time.")
                    .foregroundStyle(.secondary)
            }

            ForEach(model.limits.limits) { limit in
                LimitRow(limit: limit)
            }
            .onDelete { offsets in
                model.limits.remove(at: offsets)
            }
        }
        .navigationTitle("Limits")
        .toolbar {
            Button {
                model.limits.add(
                    AppLimit(displayName: "New limit", dailyLimitMinutes: 30)
                )
            } label: {
                Label("Add limit", systemImage: "plus")
            }
        }
    }
}

private struct LimitRow: View {
    @EnvironmentObject private var model: AppModel
    let limit: AppLimit

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(limit.displayName)
                Text("\(limit.dailyLimitMinutes) min / day")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Toggle("Enabled", isOn: Binding(
                get: { limit.isEnabled },
                set: { _ in model.limits.toggle(limit) }
            ))
            .labelsHidden()
        }
    }
}
