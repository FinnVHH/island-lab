import SwiftUI

struct ContentView: View {
    @StateObject private var controller = ActivityController()
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("title") private var title = "My first Island"
    @AppStorage("message") private var message = "Hello from my iPhone!"
    @AppStorage("progress") private var progress = 0.5
    @AppStorage("accent") private var accent = IslandAccent.mint.rawValue
    @AppStorage("symbol") private var symbol = IslandSymbol.sparkles.rawValue

    private var state: IslandAttributes.ContentState {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return .init(
            title: trimmedTitle.isEmpty ? "My Island" : String(trimmedTitle.prefix(40)),
            message: String(message.prefix(120)),
            progress: min(1, max(0, progress)),
            accent: IslandAccent(rawValue: accent) ?? .mint,
            symbol: IslandSymbol(rawValue: symbol) ?? .sparkles
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    IslandCard(state: state)
                        .foregroundStyle(.white)
                        .background(.black, in: RoundedRectangle(cornerRadius: 22))
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .listRowBackground(Color.clear)
                } header: {
                    Text("Lock Screen preview")
                } footer: {
                    Text("Approximate preview. iOS controls the final presentation.")
                }

                Section("Make it yours") {
                    TextField("Title", text: $title)
                    TextField("Message", text: $message, axis: .vertical)
                        .lineLimit(1...3)
                    Picker("Color", selection: $accent) {
                        ForEach(IslandAccent.allCases) { item in
                            Text(item.rawValue.capitalized).tag(item.rawValue)
                        }
                    }
                    Picker("Icon", selection: $symbol) {
                        ForEach(IslandSymbol.allCases) { item in
                            Label(item.rawValue.capitalized, systemImage: item.systemName)
                                .tag(item.rawValue)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Progress: \(Int(state.progress * 100))%")
                        Slider(value: $progress, in: 0...1, step: 0.01)
                            .accessibilityLabel("Progress")
                    }
                }

                Section {
                    Button {
                        Task { await controller.startOrUpdate(state) }
                    } label: {
                        Label(controller.isRunning ? "Update Live Activity" : "Start Live Activity",
                              systemImage: controller.isRunning ? "arrow.clockwise" : "play.fill")
                    }
                    .disabled(controller.isBusy)

                    Button(role: .destructive) {
                        Task { await controller.stop() }
                    } label: {
                        Label("Stop Live Activity", systemImage: "stop.fill")
                    }
                    .disabled(!controller.isRunning || controller.isBusy)
                } footer: {
                    Text(controller.status)
                        .accessibilityAddTraits(.updatesFrequently)
                }

                Section("Try it on your iPhone") {
                    Text("1. Tap Start Live Activity.\n2. Go to the Home Screen.\n3. Touch and hold the Island to expand it.\n4. Lock your phone to see the larger card.")
                    Text("Edit here and tap Update to apply changes. This experiment updates from the app; it has no server or background polling.")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Island Lab")
            .tint(state.accent.color)
            .task { controller.refresh() }
            .onChange(of: scenePhase) { _, phase in
                if phase == .active { controller.refresh() }
            }
        }
    }
}
