

import XCTest
@testable import EmptyWindow

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class EmptyWindowTests: XCTestCase {
    
    var viewController = ViewController()
    
    override class func setUp() {
        print("class setting up")
    }
    
    override class func tearDown() {
        print("class tearing down")
    }

    override func setUp() {
        print("setting up")
        super.setUp()
        let b = Bundle(for:type(of: self)) // just testing
        print(b)
        self.addTeardownBlock {
            print("new tear down 2")
        }

    }
    
    override func tearDown() {
        print("old tear down")
        super.tearDown()
    }
    
    func testDogMyCats() {
        self.addTeardownBlock {
            print("new tear down")
        }

        if let viewController =
            (UIApplication.shared.delegate as? AppDelegate)?
                .window?.rootViewController as? ViewController {
            print(viewController)
        }
        
        let input = "cats"
        let output = "dogs"
        XCTAssertEqual(output,
                       self.viewController.dogMyCats(input),
                       "Failed to produce \(output) from \(input)")
        
    }
    
    
    func testAsyncExample() {
        let ex = XCTestExpectation()
        delay(5) {
            ex.fulfill()
        }
        let result = XCTWaiter.wait(for: [ex], timeout: 10)
        // to fail, set timeout to something shorter than 5
        XCTAssert(result == .completed, "result was \(result.rawValue)")
    }
    
    func testPerformanceExample() {
        // test, set baseline, then add a zero and test again to fail
        let ct = 100000
        let d = Dictionary(uniqueKeysWithValues: zip(0...,0...ct))
        func fetch() {
            for k in 0..<ct {
                _ = d[k]
            }
        }
        measure {
            fetch()
        }
    }
    
}
