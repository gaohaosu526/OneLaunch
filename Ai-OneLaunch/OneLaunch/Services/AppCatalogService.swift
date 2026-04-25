import UIKit

final class AppCatalogService {
    static let shared = AppCatalogService()
    private init() {}

    func fetchAllApps() -> [AppItem] {
        let proxies = fetchProxies()
        guard !proxies.isEmpty else { return [] }
        return proxies
            .compactMap { proxy -> AppItem? in
                guard let bundleID = proxy.applicationIdentifier, !bundleID.isEmpty else { return nil }
                let name = proxy.localizedName ?? bundleID
                let scheme = proxy.claimedURLSchemes?.first
                return AppItem(bundleID: bundleID, name: name, urlScheme: scheme)
            }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            .enumerated()
            .map { index, item in
                var copy = item
                copy.order = index
                return copy
            }
    }

    private func fetchProxies() -> [LSApplicationProxy] {
        guard let ws = LSApplicationWorkspace.default() else { return [] }
        return ws.allApplications() ?? ws.allInstalledApplications() ?? []
    }

    func icon(for bundleID: String) -> UIImage? {
        guard let ws = LSApplicationWorkspace.default() else { return nil }
        let apps = ws.allApplications() ?? ws.allInstalledApplications()
        return apps?.first(where: { $0.applicationIdentifier == bundleID })?.icon()
    }
}
