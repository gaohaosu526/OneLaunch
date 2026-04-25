import Foundation
import SwiftData

@Model
final class AppGroup {
    var id: UUID
    var name: String
    var order: Int
    var appBundleIDs: [String]

    init(name: String, order: Int = 0) {
        self.id = UUID()
        self.name = name
        self.order = order
        self.appBundleIDs = []
    }
}
