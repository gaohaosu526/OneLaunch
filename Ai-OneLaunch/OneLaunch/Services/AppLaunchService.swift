import UIKit

final class AppLaunchService {
    static let shared = AppLaunchService()
    private init() {}

    func launch(_ app: AppItem) {
        if let ws = LSApplicationWorkspace.default(), ws.openApplicationWithBundleID(app.bundleID) { return }
        guard let scheme = app.urlScheme,
              let url = URL(string: "\(scheme)://") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
