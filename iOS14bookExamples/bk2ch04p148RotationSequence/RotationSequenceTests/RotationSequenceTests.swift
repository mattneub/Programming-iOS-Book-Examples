

import XCTest
@testable import RotationSequence


class RotationSequenceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCountSteps() throws {
        let v = ViewController()
        XCTAssertEqual(
            v.countSteps(from: 1, to: 2, direction: .counterClockwise),
            1)
        XCTAssertEqual(
            v.countSteps(from: 1, to: 2, direction: .clockwise),
            -9)
        XCTAssertEqual(
            v.countSteps(from: 2, to: 1, direction: .counterClockwise),
            9)
        XCTAssertEqual(
            v.countSteps(from: 2, to: 1, direction: .clockwise),
            -1)
        XCTAssertEqual(
            v.countSteps(from: 2, to: 5, direction: .counterClockwise),
            3)
        XCTAssertEqual(
            v.countSteps(from: 2, to: 5, direction: .clockwise),
            -7)
        XCTAssertEqual(
            v.countSteps(from: 5, to: 2, direction: .counterClockwise),
            7)
        XCTAssertEqual(
            v.countSteps(from: 5, to: 2, direction: .clockwise),
            -3)
    }


}
