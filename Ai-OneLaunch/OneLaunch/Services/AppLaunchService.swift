import UIKit

final class AppLaunchService {
    static let shared = AppLaunchService()
    private init() {}

    func launch(_ app: AppItem) {
        // Try private API first (most reliable for sideloaded apps)
        let workspace = LSApplicationWorkspace.defaultWorkspace()
        if workspace.openApplication(withBundleID: app.bundleID) { return }

        // Fallback: URL scheme
        guard let scheme = app.urlScheme,
              let url = URL(string: "\(scheme)://") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
