import SwiftUI
import SwiftData

struct HomeView: View {
    @ObservedObject var vm: HomeViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var groups: [AppGroup]

    @State private var showNewGroupSheet = false
    @State private var newGroupName = ""
    @State private var selectedAppForGroup: AppItem?
    @State private var draggingApp: AppItem?

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    var body: some View {
        NavigationStack {
            ScrollView {
                SearchBar(text: $vm.searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)

                if !groups.isEmpty && vm.searchText.isEmpty {
                    groupsRow
                }

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(vm.filteredApps) { app in
                        AppIconView(app: app, icon: vm.icon(for: app.bundleID)) {
                            vm.launch(app)
                        } onLongPress: {
                            selectedAppForGroup = app
                        }
                        .opacity(draggingApp?.id == app.id ? 0.4 : 1.0)
                        .onDrag {
                            draggingApp = app
                            return NSItemProvider(object: app.bundleID as NSString)
                        }
                        .onDrop(of: [.text], isTargeted: nil) { providers in
                            guard let dragged = draggingApp, dragged.id != app.id else { return false }
                            vm.moveApp(dragged, onto: app)
                            draggingApp = nil
                            return true
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .animation(.default, value: vm.apps)
            }
            .navigationTitle("OneLaunch")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showNewGroupSheet = true } label: {
                        Image(systemName: "folder.badge.plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showNewGroupSheet) { newGroupSheet }
        .sheet(item: $selectedAppForGroup) { app in addToGroupSheet(app: app) }
    }

    // MARK: - Groups Row

    private var groupsRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("分组").font(.headline).padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(groups) { group in
                        GroupView(
                            group: group,
                            apps: vm.apps,
                            iconProvider: { vm.icon(for: $0) },
                            onAppTap: { vm.launch($0) },
                            onRemoveApp: { vm.removeApp($0, from: group, context: modelContext) }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Sheets

    private var newGroupSheet: some View {
        NavigationStack {
            Form {
                Section("分组名称") {
                    TextField("例如：社交、工具…", text: $newGroupName)
                }
            }
            .navigationTitle("新建分组")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { showNewGroupSheet = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("创建") {
                        guard !newGroupName.isEmpty else { return }
                        vm.createGroup(name: newGroupName, context: modelContext)
                        newGroupName = ""
                        showNewGroupSheet = false
                    }
                    .disabled(newGroupName.isEmpty)
                }
            }
        }
        .presentationDetents([.height(220)])
    }

    private func addToGroupSheet(app: AppItem) -> some View {
        NavigationStack {
            List(groups) { group in
                Button {
                    vm.addApp(app, to: group, context: modelContext)
                    selectedAppForGroup = nil
                } label: {
                    HStack {
                        Image(systemName: "folder")
                        Text(group.name)
                        Spacer()
                        if group.appBundleIDs.contains(app.bundleID) {
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .navigationTitle("添加「\(app.name)」到分组")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("完成") { selectedAppForGroup = nil }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - SearchBar

private struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.secondary)
            TextField("搜索应用", text: $text).autocorrectionDisabled()
            if !text.isEmpty {
                Button { text = "" } label: {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
