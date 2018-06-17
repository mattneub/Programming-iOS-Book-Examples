

import UIKit

open class MyClass {
    open func test() {
        print("test")
    }
    public init() {}
}

/*
extension MyClass {
    func test() { // invalid redeclaration
        print("extension test")
    }
    // and if you say override, it says it doesn't override anything
}
 */

extension MyClass {
    open func test2() {
        print("test2 declared in an extension")
    }
}

