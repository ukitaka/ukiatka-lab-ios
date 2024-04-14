import Shimmer
import SwiftUI

struct Skeleton: View {
    var body: some View {
        Rectangle()
            .fill(Color(white: 0.9))
            .cornerRadius(13.0)
            .clipped()
            .shimmering(
                animation:
                Animation
                    .linear(duration: 0.5)
                    .delay(0.2).repeatForever(autoreverses: false),
                bandSize: 0.6
            )
    }
}
