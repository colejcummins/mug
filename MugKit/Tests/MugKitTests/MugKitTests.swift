import XCTest
@testable import MugKit

final class MugKitTests: XCTestCase {
    func testAppLimitDailyLimitConvertsMinutesToSeconds() {
        let limit = AppLimit(displayName: "Safari", dailyLimitMinutes: 30)
        XCTAssertEqual(limit.dailyLimit, 1800)
    }

    func testUsageSummaryFormatsHoursAndMinutes() {
        let summary = UsageSummary(displayName: "Xcode", duration: 72 * 60)
        XCTAssertEqual(summary.formattedDuration, "1h 12m")
    }

    func testStubServiceReturnsSampleUsage() async {
        let service = StubScreenTimeService()
        let usage = await service.currentUsage()
        XCTAssertFalse(usage.isEmpty)
    }

    @MainActor
    func testLimitStoreAddsAndPersistsViaInjectedDefaults() {
        let defaults = UserDefaults(suiteName: "mug.tests")!
        defaults.removePersistentDomain(forName: "mug.tests")

        let store = LimitStore(defaults: defaults)
        store.add(AppLimit(displayName: "youtube.com", kind: .webDomain))
        XCTAssertEqual(store.limits.count, 1)

        // A fresh store backed by the same defaults should see the persisted value.
        let reloaded = LimitStore(defaults: defaults)
        XCTAssertEqual(reloaded.limits.first?.displayName, "youtube.com")
    }
}
