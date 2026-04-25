import UIKit

final class AppCatalogService {
    static let shared = AppCatalogService()
    private init() {}

    func fetchAllApps() -> [AppItem] {
        let workspace = LSApplicationWorkspace.defaultWorkspace()
        guard let proxies = workspace.allApplications() as? [LSApplicationProxy] else {
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
        let workspace = LSApplicationWorkspace.defaultWorkspace()
        guard let proxies = workspace.allApplications() as? [LSApplicationProxy],
              let proxy = proxies.first(where: { $0.applicationIdentifier == bundleID }) else {
            return nil
        }
        if let img = proxy.icon() { return img }
        return nil
    }
}
