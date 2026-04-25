import UIKit

final class AppCatalogService {
    static let shared = AppCatalogService()
    private init() {}

    private var proxyCache: [String: LSApplicationProxy] = [:]

    func fetchAllApps() -> [AppItem] {
        let proxies = ObjcSafeGetApplications() ?? []
        proxyCache = proxies.reduce(into: [:]) { dict, proxy in
            if let bid = proxy.applicationIdentifier { dict[bid] = proxy }
        }
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

    func icon(for bundleID: String) -> UIImage? {
        guard let proxy = proxyCache[bundleID] else { return nil }
        return ObjcSafeGetIcon(proxy)
    }
}
