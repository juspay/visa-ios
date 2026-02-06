import SwiftUI

struct DestinationCardView: View {
    let destination: Destination
    var itemWidth: CGFloat = 140
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: destination.imageURL ?? "")) { phase in
                switch phase {
                case .empty:
                    // Placeholder while loading
                    ProgressView()
                        .frame(width: itemWidth, height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: itemWidth, height: 200)
                        .clipped()
                case .failure:
                    // Fallback image if network fails
                    if let arrow = ImageLoader.bundleImage(named: Constants.Icons.destinatioPlaceholder) {
                     arrow
                        .resizable()
                        .scaledToFill()
                        .frame(width: itemWidth, height: 200)
                        .clipped()
                         .foregroundColor(Color(hex: Constants.HexColors.primary))
                 }
                @unknown default:
                    EmptyView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // MARK: - Gradient Overlay
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                startPoint: .bottom,
                endPoint: .center
            )
            .frame(width: itemWidth, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .offset(y: 0)
            
            // MARK: - Text
            Text(destination.name)
                .font(.custom(Constants.Font.openSansBold, size: 16))
                .foregroundColor(.white)
                .lineLimit(3)
                .truncationMode(.tail)
                .frame(alignment: .leading)
                .padding(.horizontal, 4)
                .padding(.bottom, 10)
        }
        .frame(width: itemWidth, height: 200)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}
