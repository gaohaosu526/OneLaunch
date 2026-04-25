import SwiftUI

struct GroupView: View {
    let group: AppGroup
    let apps: [AppItem]
    let iconProvider: (String) -> UIImage?
    var onAppTap: ((AppItem) -> Void)?
    var onRemoveApp: ((AppItem) -> Void)?

    @State private var isExpanded = false

    var groupApps: [AppItem] {
        group.appBundleIDs.compactMap { id in apps.first { $0.bundleID == id } }
    }

    var body: some View {
        VStack(spacing: 4) {
            Button {
                withAnimation(.spring(response: 0.3)) { isExpanded.toggle() }
            } label: {
                FolderIconView(apps: Array(groupApps.prefix(4)), iconProvider: iconProvider)
            }

            Text(group.name)
                .font(.caption2)
                .lineLimit(1)
                .frame(width: 72)
        }
        .sheet(isPresented: $isExpanded) {
            GroupDetailView(
                group: group,
                apps: groupApps,
                iconProvider: iconProvider,
                onAppTap: onAppTap,
                onRemoveApp: onRemoveApp
            )
            .presentationDetents([.medium, .large])
        }
    }
}

private struct FolderIconView: View {
    let apps: [AppItem]
    let iconProvider: (String) -> UIImage?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemGray4))
                .frame(width: 60, height: 60)

            LazyVGrid(columns: Array(repeating: GridItem(.fixed(24), spacing: 2), count: 2), spacing: 2) {
                ForEach(Array(apps.prefix(4)), id: \.id) { app in
                    if let img = iconProvider(app.bundleID) {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(.systemGray3))
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(6)
        }
    }
}

private struct GroupDetailView: View {
    let group: AppGroup
    let apps: [AppItem]
    let iconProvider: (String) -> UIImage?
    var onAppTap: ((AppItem) -> Void)?
    var onRemoveApp: ((AppItem) -> Void)?

    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(apps) { app in
                        AppIconView(app: app, icon: iconProvider(app.bundleID), onTap: {
                            onAppTap?(app)
                        })
                        .contextMenu {
                            Button(role: .destructive) {
                                onRemoveApp?(app)
                            } label: {
                                Label("从分组移除", systemImage: "folder.badge.minus")
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(group.name)
        }
    }
}
