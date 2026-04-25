import SwiftUI
import SwiftData

struct SettingsView: View {
    @ObservedObject var vm: HomeViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var groups: [AppGroup]

    var body: some View {
        NavigationStack {
            Form {
                Section("分组管理") {
                    if groups.isEmpty {
                        Text("暂无分组，在启动器页面点击右上角创建").foregroundColor(.secondary)
                    } else {
                        ForEach(groups) { group in
                            HStack {
                                Image(systemName: "folder")
                                Text(group.name)
                                Spacer()
                                Text("\(group.appBundleIDs.count) 个应用")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { vm.deleteGroup(groups[$0], context: modelContext) }
                        }
                    }
                }

                Section("应用信息") {
                    LabeledContent("已识别应用", value: "\(vm.apps.count) 个")
                    LabeledContent("版本", value: "1.0")
                }
            }
            .navigationTitle("设置")
        }
    }
}
