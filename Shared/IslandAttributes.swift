import ActivityKit
import SwiftUI

struct IslandAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var title: String
        var message: String
        var progress: Double
        var accent: IslandAccent
        var symbol: IslandSymbol
    }

    var name: String
}

enum IslandAccent: String, Codable, CaseIterable, Identifiable {
    case mint, blue, orange, pink
    var id: String { rawValue }
    var color: Color {
        switch self {
        case .mint: return .mint
        case .blue: return .cyan
        case .orange: return .orange
        case .pink: return .pink
        }
    }
}

enum IslandSymbol: String, Codable, CaseIterable, Identifiable {
    case sparkles, heart, bolt, star
    var id: String { rawValue }
    var systemName: String {
        self == .sparkles ? "sparkles" : "\(rawValue).fill"
    }
}

struct IslandCard: View {
    let state: IslandAttributes.ContentState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: state.symbol.systemName)
                    .font(.title2)
                    .foregroundStyle(state.accent.color)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text(state.title).font(.headline).lineLimit(1)
                    Text(state.message).font(.subheadline)
                        .foregroundStyle(.secondary).lineLimit(2)
                }
                Spacer(minLength: 0)
                Text(state.progress, format: .percent.precision(.fractionLength(0)))
                    .font(.headline.monospacedDigit())
            }
            ProgressView(value: state.progress).tint(state.accent.color)
                .accessibilityLabel("Progress")
        }
        .padding(16)
    }
}
