
import XCTest
@testable import EmptyWindow

class EmptyWindowTests: XCTestCase {
    
    var viewController = ViewController()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDogMyCats() {
        if let viewController =
            (UIApplication.sharedApplication().delegate as? AppDelegate)?
                .window?.rootViewController as? ViewController {
                    print(viewController)
        }

        let input = "cats"
        let output = "dogs"
        XCTAssertEqual(output,
            self.viewController.dogMyCats(input),
            "Failed to produce \(output) from \(input)")
    }

    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
