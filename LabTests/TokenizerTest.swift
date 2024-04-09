import XCTest
@testable import Lab

final class TokenizerTest: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testTokenize() throws {
        let tokens = tokenize(text: "func id")
        XCTAssertEqual(tokens, ["func", "id"])
    }
}
