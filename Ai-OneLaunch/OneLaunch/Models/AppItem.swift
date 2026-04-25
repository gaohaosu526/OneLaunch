import Foundation

struct AppItem: Identifiable, Hashable, Codable {
    let id: UUID
    let bundleID: String
    let name: String
    let urlScheme: String?
    var order: Int
    var groupID: UUID?

    init(bundleID: String, name: String, urlScheme: String? = nil, order: Int = 0) {
        self.id = UUID()
        self.bundleID = bundleID
        self.name = name
        self.urlScheme = urlScheme
        self.order = order
    }
}
