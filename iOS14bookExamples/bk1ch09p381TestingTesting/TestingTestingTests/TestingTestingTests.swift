

import XCTest
@testable import TestingTesting

class Thing {
    init() {
        print("hello from Thing")
    }
    deinit {
        print("farewell from Thing")
    }
}

class TestingTestingTests: XCTestCase {
    
    let thing = Thing()
    var string = "original value" {
        didSet {
            print("string was", oldValue)
            print("now it is", string)
        }
    }

    override func setUpWithError() throws {
        print("setup")
    }

    override func tearDownWithError() throws {
    }

    func test_one() {
        print(self.thing)
        print("one")
        self.string = "one"
    }
    
    func test_two() {
        print(self.thing)
        print("two")
        self.string = "two"
    }

    deinit {
        print("farewell from test case")
    }
}
