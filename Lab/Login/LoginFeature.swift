import ComposableArchitecture
import SwiftUI

@Reducer
struct LoginFeature {
    @ObservableState
    struct State {
        enum Status {
            case initialLoading
            case inputting
            case submitting
            case error(Error)
        }

        var status: Status = .initialLoading
        var username: String = ""
        var password: String = ""
    }

    enum Action: BindableAction {
        case initialLoadStarted
        case initialLoadCompleted
        case loginButtonTapped
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .initialLoadStarted:
                return .run { send in
                    _ = try? await client.auth.user()
                    await send(.initialLoadCompleted)
                }

            case .initialLoadCompleted:
                state.status = .inputting
                return .none

            case .loginButtonTapped:
                return .run { [username = state.username, password = state.password] _ in
                    do {
                        let session = try await client.auth.signIn(email: username, password: password)
                        print(session.user.email ?? "no-email")
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

struct LoginView: View {
    @Bindable var store: StoreOf<LoginFeature>

    @ViewBuilder
    var body: some View {
        switch store.status {
        case .initialLoading:
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2, anchor: .center)
                .onAppear {
                    store.send(.initialLoadStarted)
                }

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

        case let .error(error):
            Text(error.localizedDescription)
        }
    }
}

#Preview {
    LoginView(
        store: Store(initialState: LoginFeature.State()) {}
    )
}
