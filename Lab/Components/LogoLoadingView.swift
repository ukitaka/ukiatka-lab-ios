import SwiftUI

struct LogoLoadingView: View {
    @State private var rotationDegrees = 0.0
    @State private var opacity = 0.0

    private var rotateAnimation: Animation {
        .easeInOut
            .speed(0.3)
            .repeatForever(autoreverses: false)
    }

    var body: some View {
        Image("Icon")
            .resizable()
            .frame(width: 64, height: 64)
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
