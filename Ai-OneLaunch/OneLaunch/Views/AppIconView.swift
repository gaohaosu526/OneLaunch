import SwiftUI

struct AppIconView: View {
    let app: AppItem
    let icon: UIImage?
    var onTap: (() -> Void)?
    var onLongPress: (() -> Void)?

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemGray5))
                    .frame(width: 60, height: 60)

                if let icon {
                    Image(uiImage: icon)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                } else {
                    Image(systemName: "app.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                }
            }
            .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)

            Text(app.name)
                .font(.caption2)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 72)
        }
        .onTapGesture { onTap?() }
        .onLongPressGesture { onLongPress?() }
    }
}
