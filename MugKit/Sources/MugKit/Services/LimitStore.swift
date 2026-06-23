import Foundation

/// Persists the user's limits to the shared App Group `UserDefaults` so the app and its
/// extensions see the same list. Observable so SwiftUI views update automatically.
@MainActor
public final class LimitStore: ObservableObject {
    @Published public private(set) var limits: [AppLimit] = []

    private let defaults: UserDefaults
    private let storageKey = "mug.limits"

    /// Uses the shared App Group suite when available, falling back to standard defaults
    /// (e.g. in tests or previews where the group isn't provisioned).
    public init(defaults: UserDefaults? = nil) {
        self.defaults = defaults
            ?? UserDefaults(suiteName: MugIdentifiers.appGroup)
            ?? .standard
        load()
    }

    public func add(_ limit: AppLimit) {
        limits.append(limit)
        save()
    }

    public func update(_ limit: AppLimit) {
        guard let index = limits.firstIndex(where: { $0.id == limit.id }) else { return }
        limits[index] = limit
        save()
    }

    public func remove(at offsets: IndexSet) {
        limits.remove(atOffsets: offsets)
        save()
    }

    public func toggle(_ limit: AppLimit) {
        guard let index = limits.firstIndex(where: { $0.id == limit.id }) else { return }
        limits[index].isEnabled.toggle()
        save()
    }

    private func load() {
        guard let data = defaults.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([AppLimit].self, from: data) else { return }
        limits = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(limits) else { return }
        defaults.set(data, forKey: storageKey)
    }
}
