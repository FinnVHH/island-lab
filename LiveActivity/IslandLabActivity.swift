import ActivityKit
import SwiftUI
import WidgetKit

@main
struct IslandLabWidgetBundle: WidgetBundle {
    var body: some Widget { IslandLabLiveActivity() }
}

struct IslandLabLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IslandAttributes.self) { context in
            IslandCard(state: context.state)
                .activityBackgroundTint(.black)
                .activitySystemActionForegroundColor(.white)
                .foregroundStyle(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: context.state.symbol.systemName)
                        .font(.title2)
                        .foregroundStyle(context.state.accent.color)
                        .accessibilityLabel(context.state.symbol.rawValue)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    percentage(context.state.progress)
                        .foregroundStyle(context.state.accent.color)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.title).font(.headline).lineLimit(1)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(context.state.message).font(.subheadline).lineLimit(2)
                        ProgressView(value: context.state.progress)
                            .tint(context.state.accent.color)
                            .accessibilityLabel("Progress")
                    }
                    .padding(.top, 4)
                }
            } compactLeading: {
                Image(systemName: context.state.symbol.systemName)
                    .foregroundStyle(context.state.accent.color)
                    .accessibilityLabel(context.state.title)
            } compactTrailing: {
                percentage(context.state.progress)
                    .foregroundStyle(context.state.accent.color)
            } minimal: {
                Image(systemName: context.state.symbol.systemName)
                    .foregroundStyle(context.state.accent.color)
                    .accessibilityLabel(context.state.title)
            }
            .keylineTint(context.state.accent.color)
        }
    }

    private func percentage(_ value: Double) -> some View {
        Text(value, format: .percent.precision(.fractionLength(0)))
            .font(.caption.monospacedDigit())
    }
}
