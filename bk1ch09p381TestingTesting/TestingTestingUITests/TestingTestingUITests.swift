//
//  TestingTestingUITests.swift
//  TestingTestingUITests
//
//  Created by Matt Neuburg on 9/11/20.
//

import XCTest

class Thing {
    init() {
        print("hello from Thing")
    }
    deinit {
        print("farewell from Thing")
    }
}

class TestingTestingUITests: XCTestCase {
    
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
        let app = XCUIApplication()
        app.launch()

        print(self.thing)
        print("one")
        self.string = "one"
    }
    
    func test_two() {
        let app = XCUIApplication()
        app.launch()

        print(self.thing)
        print("two")
        self.string = "two"
    }
    
    deinit {
        print("farewell from test case")
    }


}
