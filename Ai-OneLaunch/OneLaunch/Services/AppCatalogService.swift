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
        // Try LSApplicationWorkspace.default()
        if let ws = LSApplicationWorkspace.default() {
            if let apps = ws.allApplications(), !apps.isEmpty { return apps }
            if let apps = ws.allInstalledApplications(), !apps.isEmpty { return apps }
        }
        // Try LSApplicationWorkspace.defaultWorkspace()
        if let ws = LSApplicationWorkspace.defaultWorkspace() {
            if let apps = ws.allApplications(), !apps.isEmpty { return apps }
            if let apps = ws.allInstalledApplications(), !apps.isEmpty { return apps }
        }
        // ObjC runtime fallback
        return fetchProxiesViaRuntime()
    }

    private func fetchProxiesViaRuntime() -> [LSApplicationProxy] {
        guard let cls = NSClassFromString("LSApplicationWorkspace") as? NSObject.Type else { return [] }
        let selectors = ["defaultWorkspace", "default", "sharedInstance"]
        var workspace: NSObject?
        for selName in selectors {
            let sel = NSSelectorFromString(selName)
            if cls.responds(to: sel) {
                workspace = cls.perform(sel)?.takeUnretainedValue() as? NSObject
                if workspace != nil { break }
            }
        }
        guard let ws = workspace else { return [] }
        let appSelectors = ["allApplications", "allInstalledApplications"]
        for selName in appSelectors {
            let sel = NSSelectorFromString(selName)
            if ws.responds(to: sel),
               let result = ws.perform(sel)?.takeUnretainedValue() as? [LSApplicationProxy],
               !result.isEmpty {
                return result
            }
        }
        return []
    }

    func icon(for bundleID: String) -> UIImage? {
        if let ws = LSApplicationWorkspace.default() ?? LSApplicationWorkspace.defaultWorkspace(),
           let proxy = (ws.allApplications() ?? ws.allInstalledApplications())?.first(where: { $0.applicationIdentifier == bundleID }) {
            return proxy.icon()
        }
        return nil
    }
}
