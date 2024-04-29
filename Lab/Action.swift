enum APIRequestAction<Response> {
    case startFetching
    case completed(Response)
    case error(Error)
}

enum DialogAction {
    case confirmation
    case executeAction
    case completed
}
