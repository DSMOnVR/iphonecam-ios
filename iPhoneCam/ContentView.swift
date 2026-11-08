import SwiftUI

struct ContentView: View {
    @AppStorage("serverURL") private var serverURL: String = ""
    @StateObject private var store = ServerStore()
    @State private var activeURL: URL?
    @State private var showSetup = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            if let url = activeURL {
                WebView(url: url)
                    .ignoresSafeArea()

                Button {
                    showSetup = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.45), in: Circle())
                }
                .padding(12)
            } else {
                SetupView(serverURL: $serverURL, store: store, onConnect: { url in
                    activeURL = url
                })
            }
        }
        .onAppear {
            if activeURL == nil, let url = Self.makeURL(serverURL) {
                activeURL = url
            }
        }
        .sheet(isPresented: $showSetup) {
            SetupView(serverURL: $serverURL, store: store, onConnect: { url in
                activeURL = url
                showSetup = false
            })
        }
    }

    static func makeURL(_ raw: String) -> URL? {
        var t = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if t.isEmpty { return nil }
        if !t.contains("://") { t = "https://" + t }
        if !t.hasSuffix("/") { t += "/" }
        return URL(string: t)
    }
}
