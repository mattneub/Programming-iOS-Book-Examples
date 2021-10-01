

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.testDefer()
        do {
            try self.testDeferWithThrow()
        } catch {
            print("catching")
        }
        testDeferWithOtherBlocks()
        testDeferWithThrow2()
    }
    
    let which = 0
    
    func testDefer() {
        print("starting")
        defer {
            print("ending")
        }
        if which == 1 {
            print("returning")
            return
        }
        print("last line")
    }

    // okay, but let's also try other ways of escaping
    // what if we throw?
    
    func testDeferWithThrow() throws {
        print("starting2")
        defer {
            print("ending2")
        }
        throw NSError(domain: "Ouch", code: 1, userInfo: nil)
    }
    
    func testDeferWithThrow2() {
        print("starting2")
        do {
            defer {
                print("ending2")
            }
            print("throwing")
            throw NSError(domain: "Ouch", code: 1, userInfo: nil)
        } catch {
            print("caught: \(error)")
        }
    }

    // finally, let's also try other kinds of block
    
    func testDeferWithOtherBlocks() {
        print("entering func")
        defer {
            print ("exiting func")
        }
        test: while true {
            print ("entering while")
            defer {
                print ("exiting while")
            }
            if which == 1 {
                print ("entering if")
                defer {
                    print ("exiting if")
                }
                print ("breaking from if")
                break test
            }
            print ("breaking from while")
            break test
        }
    }
    
    func doSomethingTimeConsuming() {
        self.view.window?.isUserInteractionEnabled = false
        // ... do stuff ...
        self.view.window?.isUserInteractionEnabled = true
    }
    
    var somethingHappened = true
    func doSomethingTimeConsuming2() {
        self.view.window?.isUserInteractionEnabled = false
        // ... do stuff ...
        if somethingHappened {
            return
        }
        // ... do more stuff ...
        self.view.window?.isUserInteractionEnabled = true
    }

    func doSomethingTimeConsuming3() {
        defer {
            self.view.window?.isUserInteractionEnabled = true
        }
        self.view.window?.isUserInteractionEnabled = false
        // ... do stuff ...
        if somethingHappened {
            return
        }
        // ... do more stuff ...
    }




}

