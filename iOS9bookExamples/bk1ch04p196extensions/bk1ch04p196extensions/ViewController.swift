

import UIKit

extension Array {
    mutating func shuffle () {
        for i in (0..<self.count).reverse() {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    }
}

extension Array {
    mutating func removeAtIndexes (ixs:[Int]) -> () {
        for i in ixs.sort(>) {
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
    func sizeByDelta(dw dw:CGFloat, dh:CGFloat) -> CGSize {
        return CGSizeMake(self.width + dw, self.height + dh)
    }
}

extension UIColor {
    class func myGoldenColor() -> UIColor {
        return self.init(red:1.000, green:0.894, blue:0.541, alpha:0.900)
    }
}

// example no longer needed, they fixed it

//extension CGAffineTransform : CustomStringConvertible {
//    public var description : String {
//        return NSStringFromCGAffineTransform(self)
//    }
//}

class Dog<T> {
    var name : T?
}
extension Dog {
    func sayYourName() -> T? { // T is the type of self.name
        return self.name
    }
}
extension Dog where T : Equatable {
    
}

extension Array where Element:Comparable {
    func min() -> Element {
        var minimum = self[0]
        for ix in 1..<self.count {
            if self[ix] < minimum {
                minimum = self[ix]
            }
        }
        return minimum
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

protocol Flier {
}
extension Flier {
    func fly() {
        print("flap flap flap")
    }
}
struct Bird : Flier {
}
struct Insect : Flier {
    func fly() {
        print("whirr")
    }
}
class Rocket : Flier {
    func fly() {
        print("zoooom")
    }
}
class AtlasRocket : Rocket {
    override func fly() {
        print("ZOOOOOM")
    }
}
class Daedalus : Flier {
    // nothing
}
class Icarus : Daedalus {
    func fly() {
        print("fall into the sea")
    }
}

protocol Flier2 {
    func fly() // *
}
extension Flier2 {
    func fly() {
        print("flap flap flap")
    }
}
struct Bird2 : Flier2 {
}
struct Insect2 : Flier2 {
    func fly() {
        print("whirr")
    }
}
class Rocket2 : Flier2 {
    func fly() {
        print("zoooom")
    }
}
class AtlasRocket2 : Rocket2 {
    override func fly() {
        print("ZOOOOOM")
    }
}
class Daedalus2 : Flier2 {
    // nothing
}
class Icarus2 : Daedalus2 {
    func fly() {
        print("fall into the sea")
    }
}


extension RawRepresentable {
    init?(_ what:RawValue) {
        self.init(rawValue:what)
    }
}
public enum Fill : Int {
    case Empty = 1
    case Solid
    case Hazy
}
public enum Color : Int {
    case Color1 = 1
    case Color2
    case Color3
}


class ViewController: UIViewController {
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let t = CGAffineTransformMakeRotation(2)
        print(t)
        
        self.view.backgroundColor = UIColor.myGoldenColor()
        
        do {
        
            let b = Bird()
            b.fly() // flap flap flap
            (b as Flier).fly() // flap flap flap
            
            let i = Insect()
            i.fly() // whirr
            (i as Flier).fly() // flap flap flap
            
            let r = Rocket()
            r.fly() // zoooom
            (r as Flier).fly() // flap flap flap
            
            let r2 = AtlasRocket()
            r2.fly() // ZOOOOOM
            (r2 as Rocket).fly() // ZOOOOOM
            (r2 as Flier).fly() // flap flap flap
            
            let d = Daedalus()
            d.fly() // flap flap flap
            (d as Flier).fly() // flap flap flap
            
            let d2 = Icarus()
            d2.fly() // fall into the sea
            (d2 as Daedalus).fly() // flap flap flap
            (d2 as Flier).fly() // flap flap flap
            
        }
        
        // but:
        
        do {
            
            let b = Bird2()
            b.fly() // flap flap flap
            
            let i = Insect2()
            i.fly() // whirr
            (i as Flier2).fly() // whirr (!!!)
            
            let r = Rocket2()
            r.fly() // zoooom
            (r as Flier2).fly() // zoooom (!!!)
            
            let r2 = AtlasRocket2()
            r2.fly() // ZOOOOOM
            (r2 as Rocket2).fly() // ZOOOOOM
            (r2 as Flier2).fly() // ZOOOOOM (!!!)
            
            let d = Daedalus2()
            d.fly() // flap flap flap
            (d as Flier2).fly() // flap flap flap
            
            let d2 = Icarus2()
            d2.fly() // fall into the sea
            (d2 as Daedalus2).fly() // flap flap flap
            (d2 as Flier2).fly() // flap flap flap

            
        }
        
        let m = [4,1,5,7,2].min() // 1
        print(m)
        // let d = [Digit(12), Digit(42)].min() // compile error
        print([4,1,5].minElement())
        
    }
    
    

}

