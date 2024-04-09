func tokenize(text: String) -> [String] {
    return text.split(separator: " ").map(String.init)
}
