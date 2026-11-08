import Foundation
import Combine

struct SavedServer: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var url: String
}

final class ServerStore: ObservableObject {
    @Published private(set) var servers: [SavedServer] = []

    private let key = "savedServers"

    init() {
        load()
    }

    func add(name: String, url: String) {
        let display = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalName = display.isEmpty ? url : display
        servers.append(SavedServer(name: finalName, url: url))
        persist()
    }

    func remove(at offsets: IndexSet) {
        servers.remove(atOffsets: offsets)
        persist()
    }

    func remove(_ server: SavedServer) {
        servers.removeAll { $0.id == server.id }
        persist()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let list = try? JSONDecoder().decode([SavedServer].self, from: data) else {
            return
        }
        servers = list
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(servers) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
