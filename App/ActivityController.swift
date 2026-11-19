import ActivityKit
import SwiftUI

@MainActor
final class ActivityController: ObservableObject {
    @Published private(set) var isRunning = false
    @Published private(set) var isBusy = false
    @Published private(set) var status = "Ready for your first experiment."

    func refresh() {
        isRunning = !runningActivities.isEmpty
    }

    private var runningActivities: [Activity<IslandAttributes>] {
        Activity<IslandAttributes>.activities.filter {
            $0.activityState == .active || $0.activityState == .stale
        }
    }

    func startOrUpdate(_ state: IslandAttributes.ContentState) async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false; refresh() }

        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            status = "Live Activities are disabled. Enable them in Settings for Island Lab."
            return
        }

        let content = ActivityContent(state: state, staleDate: nil)
        let existing = runningActivities
        if !existing.isEmpty {
            for activity in existing { await activity.update(content) }
            status = "Updated. Leave the app to see your Island."
            return
        }

        do {
            _ = try Activity<IslandAttributes>.request(
                attributes: IslandAttributes(name: "Island Lab"),
                content: content,
                pushType: nil
            )
            status = "Started! Go to the Home Screen, then hold the Island to expand it."
        } catch {
            status = "Could not start: \(error.localizedDescription)"
        }
    }

    func stop() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false; refresh() }
        for activity in Activity<IslandAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        status = "Stopped. Change the design and start again whenever you like."
    }
}
