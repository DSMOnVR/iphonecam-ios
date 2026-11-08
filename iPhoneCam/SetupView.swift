import SwiftUI

struct SetupView: View {
    @Binding var serverURL: String
    @ObservedObject var store: ServerStore
    var onConnect: (URL) -> Void

    @State private var name: String = ""
    @State private var address: String = ""

    init(serverURL: Binding<String>, store: ServerStore, onConnect: @escaping (URL) -> Void) {
        self._serverURL = serverURL
        self._store = ObservedObject(wrappedValue: store)
        self.onConnect = onConnect
    }

    var body: some View {
        NavigationView {
            List {
                if !store.servers.isEmpty {
                    Section("Saved") {
                        ForEach(store.servers) { server in
                            Button {
                                connect(server.url)
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(server.name)
                                        .foregroundStyle(.primary)
                                    Text(server.url)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete { store.remove(at: $0) }
                    }
                }

                Section {
                    TextField("Name (e.g. Home PC)", text: $name)
                    TextField("https://192.168.1.89:8443/", text: $address)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    Button {
                        saveAndConnect()
                    } label: {
                        Label("Save & Connect", systemImage: "plus.circle.fill")
                    }
                    .disabled(address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                } header: {
                    Text("Add a server")
                } footer: {
                    Text("Run start.bat on your PC first, and install the cert on this iPhone once.")
                }
            }
            .navigationTitle("iPhoneCam")
        }
        .navigationViewStyle(.stack)
        .onAppear {
            if address.isEmpty {
                address = serverURL
            }
        }
    }

    private func saveAndConnect() {
        let url = normalized(address)
        guard !url.isEmpty else { return }
        store.add(name: name, url: url)
        name = ""
        connect(url)
    }

    private func connect(_ raw: String) {
        let url = normalized(raw)
        guard let parsed = URL(string: url) else { return }
        serverURL = url
        onConnect(parsed)
    }

    private func normalized(_ raw: String) -> String {
        var t = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if t.isEmpty { return "" }
        if !t.contains("://") { t = "https://" + t }
        if !t.hasSuffix("/") { t += "/" }
        return t
    }
}
