

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
    
    override func setUpWithError() throws {
        print("instance setting up with error")
        self.continueAfterFailure = false // "continue called harmful"?
    }

    override func setUp() {
        print("instance setting up")
        super.setUp()
        let b = Bundle(for:Self.self) // just testing
        print(b)
        self.addTeardownBlock {
            print("new tear down 2")
        }
    }
    
    override func tearDown() {
        print("old tear down")
        super.tearDown()
    }
    
    override func tearDownWithError() throws {
        print("tearing down with error")
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
    
    func testDogMyCats2() {
        XCTContext.runActivity(named: "Testing cats and dogs") { act in
            let input = "cats"
            let output = "dogs"
            let attachment = XCTAttachment(string: "Ouch")
            act.add(attachment)
            XCTAssertEqual(output,
                           self.viewController.dogMyCats(input),
                           "Failed to produce \(output) from \(input)")
        }
    }
    
    func testCustomAssertion() {
        return; // comment out to try it
        let loc = XCTSourceCodeLocation(filePath: #file, lineNumber: #line) // point of failure
        var issue = XCTIssue(type: .assertionFailure, compactDescription: "oh darn")
        issue.add(XCTAttachment(string:"yipes"))
        // issue.detailedDescription = "the mouse has eaten the hawk" // pointless? not in report...
        issue.sourceCodeContext = XCTSourceCodeContext(location: loc)
        self.record(issue)
    }
    
    func doSomethingAsynchronous(completion: @escaping (Bool) -> ()) {
        delay(0.1) {
            completion(true)
        }
    }
    
    func testAsyncExample() {
        let expect = XCTestExpectation()
        doSomethingAsynchronous { ok in
            XCTAssert(ok, "got wrong asynchronous result")
            expect.fulfill()
        }
        let result = XCTWaiter().wait(for: [expect], timeout: 0.5)
        XCTAssert(result == .completed, "did not complete properly")
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
        self.measure {
            fetch()
        }
    }
    
}
