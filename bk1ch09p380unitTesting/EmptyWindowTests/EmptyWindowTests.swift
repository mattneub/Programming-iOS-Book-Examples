//
//  EmptyWindowTests.swift
//  EmptyWindowTests
//
//  Created by Matt Neuburg on 5/9/15.
//  Copyright (c) 2015 Matt Neuburg. All rights reserved.
//

import UIKit
import XCTest
import EmptyWindow


class EmptyWindowTests: XCTestCase {
    
    var viewController = ViewController()
    // or, if we need an actual instance in the running app
    // var viewController = UIApplication.sharedApplication().delegate?.window??.rootViewController as! ViewController

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDogMyCats() {
        let input = "cats"
        let output = "dogs"
        XCTAssertEqual(output,
            self.viewController.dogMyCats(input),
            "Failed to produce \(output) from \(input)")
    }
    
}
