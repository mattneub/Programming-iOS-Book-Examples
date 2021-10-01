import UIKit

public struct Coolness {
    public init() {}
    public var text = "Hello, World!"
    // to access a bundle resource, must specify `Bundle.module`
    public func test() {
        // asset catalog
        let manny = UIImage(named: "manny", in: .module, compatibleWith: nil)
        print(manny as Any)
        let moe = UIImage(named: "moe", in: .module, compatibleWith: nil)
        print(moe as Any)
        // at base of package pseudo-target
        let jack = UIImage(named: "jack.jpg", in: .module, compatibleWith: nil)
        print(jack as Any)
    }
}
