import ComposableArchitecture
import SwiftUI

@Reducer
struct LoginFeature: Sendable {
    @ObservableState
    struct State: Equatable {
        enum Status: Equatable {
            case inputting
            case submitting
        }

        var status: Status = .inputting
        var username: String = ""
        var password: String = ""
    }

    enum Action: BindableAction {
        case startLoginFlow
        case loginButtonTapped
        case loginCompleted
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .startLoginFlow:
                return .none

            case .loginButtonTapped:
                return .run { [username = state.username, password = state.password] send in
                    do {
                        let session = try await client.auth.signIn(email: username, password: password)
                        print(session.user.email ?? "no-email")
                        await send(.loginCompleted)
                    } catch {
                        print(error)
                    }
                }

            case .loginCompleted:
                print("logged-in!!!")
                return .none
            }
        }
    }
}

struct LoginView: View {
    @Bindable var store: StoreOf<LoginFeature>

    @ViewBuilder
    var body: some View {
        switch store.status {
        case .inputting:
            Form {
                Section {
                    TextField("username", text: $store.username)
                    SecureField("password", text: $store.password)
                }
                Button("Login") {
                    store.send(.loginButtonTapped)
                }
            }

        case .submitting:
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2, anchor: .center)
        }
    }
}

#Preview {
    LoginView(
        store: Store(initialState: LoginFeature.State()) {}
    )
}
