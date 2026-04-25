import SwiftUI
import SwiftData

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var apps: [AppItem] = []
    @Published var searchText: String = ""

    private let catalog = AppCatalogService.shared
    private let launcher = AppLaunchService.shared

    var filteredApps: [AppItem] {
        guard !searchText.isEmpty else { return apps }
        return apps.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    func loadApps() {
        apps = catalog.fetchAllApps()
    }

    func launch(_ app: AppItem) {
        launcher.launch(app)
    }

    func icon(for bundleID: String) -> UIImage? {
        catalog.icon(for: bundleID)
    }

    func moveApp(_ dragged: AppItem, onto target: AppItem) {
        guard let from = apps.firstIndex(of: dragged),
              let to = apps.firstIndex(of: target),
              from != to else { return }
        apps.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
        for i in apps.indices { apps[i].order = i }
    }

    func createGroup(name: String, context: ModelContext) {
        let group = AppGroup(name: name)
        context.insert(group)
        try? context.save()
    }

    func addApp(_ app: AppItem, to group: AppGroup, context: ModelContext) {
        guard !group.appBundleIDs.contains(app.bundleID) else { return }
        group.appBundleIDs.append(app.bundleID)
        if let idx = apps.firstIndex(of: app) { apps[idx].groupID = group.id }
        try? context.save()
    }

    func removeApp(_ app: AppItem, from group: AppGroup, context: ModelContext) {
        group.appBundleIDs.removeAll { $0 == app.bundleID }
        if let idx = apps.firstIndex(of: app) { apps[idx].groupID = nil }
        try? context.save()
    }

    func deleteGroup(_ group: AppGroup, context: ModelContext) {
        for bid in group.appBundleIDs {
            if let idx = apps.firstIndex(where: { $0.bundleID == bid }) { apps[idx].groupID = nil }
        }
        context.delete(group)
        try? context.save()
    }
}
