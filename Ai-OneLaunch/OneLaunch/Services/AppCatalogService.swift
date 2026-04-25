import UIKit

final class AppCatalogService {
    static let shared = AppCatalogService()
    private init() {}

    func fetchAllApps() -> [AppItem] {
        guard let workspace = LSApplicationWorkspace.default(),
              let proxies = workspace.allApplications() else {
            return []
        }
        return proxies
            .compactMap { proxy -> AppItem? in
                guard let name = proxy.localizedName, !name.isEmpty else { return nil }
                let scheme = proxy.claimedURLSchemes?.first
                return AppItem(bundleID: proxy.applicationIdentifier, name: name, urlScheme: scheme)
            }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            .enumerated()
            .map { index, item in
                var copy = item
                copy.order = index
                return copy
            }
    }

    func icon(for bundleID: String) -> UIImage? {
        guard let workspace = LSApplicationWorkspace.default(),
              let proxies = workspace.allApplications(),
              let proxy = proxies.first(where: { $0.applicationIdentifier == bundleID }) else {
            return nil
        }
        return proxy.icon()
    }
}
