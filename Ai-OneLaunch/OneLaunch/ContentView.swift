import SwiftUI

struct ContentView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        TabView {
            HomeView(vm: vm)
                .tabItem { Label("启动器", systemImage: "square.grid.3x3.fill") }
            SettingsView(vm: vm)
                .tabItem { Label("设置", systemImage: "gear") }
        }
        .onAppear { vm.loadApps() }
    }
}
