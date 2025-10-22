import SwiftUI

struct VibeCardView: View {
    let imageName: String   
    let title: String
    var height: CGFloat = 160
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let image = ImageLoader.bundleImage(named: imageName) {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: height)
                    .clipped()
                    .cornerRadius(12)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: height)
                    .foregroundColor(.gray)
                    .cornerRadius(12)
            }
            
            // Gradient overlay for text readability
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                startPoint: .bottom,
                endPoint: .center
            )
            .frame(height: 80)
            .cornerRadius(12)
            .clipped()
            
            // Title
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding()
        }
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}

