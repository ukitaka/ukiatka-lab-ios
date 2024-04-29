import SwiftUI

extension Button {
    func labStyled(_ color: Color?) -> some View {
        background(color)
            .foregroundColor(Color.white)
            .cornerRadius(16.0)
            .fontWeight(.semibold)
    }
}
