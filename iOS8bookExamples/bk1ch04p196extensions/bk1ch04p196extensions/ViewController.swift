

import UIKit

extension Array {
    mutating func shuffle () {
        for i in stride(from:self.count-1, to:0, by:-1) {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    }
}

extension Array {
    mutating func removeAtIndexes (ixs:[Int]) -> () {
        for i in ixs.sorted(>) {
            self.removeAtIndex(i)
        }
    }
}

extension CGRect {
    var center : CGPoint {
        return CGPointMake(self.midX, self.midY)
    }
}

extension CGSize {
    func sizeByDelta(#dw:CGFloat, dh:CGFloat) -> CGSize {
        return CGSizeMake(self.width + dw, self.height + dh)
    }
}

extension UIColor {
    class func myGolden() -> UIColor {
        return self(red:1.000, green:0.894, blue:0.541, alpha:0.900)
    }
}

extension CGAffineTransform : Printable {
    public var description : String {
        return NSStringFromCGAffineTransform(self)
    }
}

class Dog<T> {
    var name : T? = nil
}
extension Dog {
    func sayYourName() -> T? { // T is the type of self.name
        return self.name
    }
}

struct Digit {
    var number : Int
}
extension Digit {
    init() {
        self.init(number:42)
    }
}
let d = Digit(number:42)



class ViewController: UIViewController {

}

