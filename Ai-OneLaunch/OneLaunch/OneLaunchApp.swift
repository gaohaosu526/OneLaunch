import SwiftUI
import SwiftData

@main
struct OneLaunchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: AppGroup.self)
    }
}
