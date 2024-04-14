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

    @Dependency(\.loginSessionClient) private var loginSessionClient

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                .none

            case .startLoginFlow:
                .none

            case .loginButtonTapped:
                .run { [username = state.username, password = state.password] send in
                    do {
                        try await loginSessionClient.login(email: username, password: password)
                        await send(.loginCompleted)
                    } catch {
                        print(error)
                    }
                }

            case .loginCompleted:
                .none
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
