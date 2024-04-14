import SwiftUI

struct LogoLoadingView: View {
    @State private var rotationDegrees = 0.0
    @State private var opacity = 0.0

    private let width: CGFloat
    private let height: CGFloat

    private var rotateAnimation: Animation {
        .easeInOut
            .speed(0.3)
            .repeatForever(autoreverses: false)
    }

    init(width: CGFloat = 64.0, height: CGFloat = 64.0) {
        self.width = width
        self.height = height
    }

    var body: some View {
        Image("Icon")
            .resizable()
            .frame(width: width, height: height)
            .rotationEffect(.degrees(rotationDegrees))
            .opacity(opacity)
            .onAppear {
                withAnimation(rotateAnimation) {
                    rotationDegrees = 360.0
                }
                withAnimation(.linear(duration: 0.1)) {
                    opacity = 1.0
                }
            }
    }
}

#Preview {
    LogoLoadingView()
}
