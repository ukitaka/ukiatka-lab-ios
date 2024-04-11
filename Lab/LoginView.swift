import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        Text("Login to ukitaka-lab")
        Form {
            TextField("username", text: $username)
            TextField("password", text: $password)
                .textContentType(.password)
        }
    }
}

#Preview {
    LoginView()
}
