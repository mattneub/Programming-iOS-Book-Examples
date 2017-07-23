

import UIKit

extension Array {
    mutating func shuffle () {
        for i in (0..<self.count).reversed() {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            // (self[ix1], self[ix2]) = (self[ix2], self[ix1])
            self.swapAt(ix1, ix2) // new way in Swift 4
        }
    }
}

extension Array {
    mutating func removeAtIndexes (ixs:[Int]) -> () {
        // for i in ixs.sorted().reversed() { // this might be clearer
        for i in ixs.sorted(by:>) { // required param label
            self.remove(at:i)
        }
    }
}

extension CGRect {
    var center : CGPoint {
        return CGPoint(x:self.midX, y:self.midY)
    }
}

extension CGSize {
    func sizeByDelta(dw:CGFloat, dh:CGFloat) -> CGSize {
        return CGSize(width:self.width + dw, height:self.height + dh)
    }
}

extension UIColor {
    class func myGolden() -> UIColor {
        return self.init(red:1.000, green:0.894, blue:0.541, alpha:0.900)
    }
}

// example no longer needed, they fixed it

//extension CGAffineTransform : CustomStringConvertible {
//    public var description : String {
//        return NSStringFromCGAffineTransform(self)
//    }
//}

enum Archive : String {
    case color = "itsColor"
    case number = "itsNumber"
    case shape = "itsShape"
    case fill = "itsFill"
}

extension NSCoder {
    func encode(_ objv: Any?, forKey key: Archive) {
        self.encode(objv, forKey:key.rawValue)
    }
}

// okay, but the problem solved by the above can now be solved another way,
// because we have key value types? need to check that

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

func myMin<T:Comparable>(_ things:T...) -> T {
    var minimum = things[0]
    for ix in 1..<things.count {
        if things[ix] < minimum { // compile error without Comparable
            minimum = things[ix]
        }
    }
    return minimum
}


extension Array where Element:Comparable {
    func myMin() -> Element {
        var minimum = self[0]
        for ix in 1..<self.count {
            if self[ix] < minimum {
                minimum = self[ix]
            }
        }
        return minimum
    }
}

/*

extension Array where Element == Int {
    
}
 
 */

extension Array where Element : NSObject {
    
}

extension Sequence where Element == Int {
    func sum() -> Int {
        return self.reduce(0, +)
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
    case empty = 1
    case solid
    case hazy
}
public enum Color : Int {
    case color1 = 1
    case color2
    case color3
}


class ViewController: UIViewController {
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let t = CGAffineTransform(rotationAngle:2)
        print(t)
        
        self.view.backgroundColor = .myGolden()
        
        let d = Digit(number:42)
        let d2 = Digit()
        _ = (d,d2)
        
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
        
        let m = [4,1,5,7,2].myMin() // 1
        print(m)
        // let d = [Digit(12), Digit(42)].min() // compile error
        print([4,1,5].myMin())
        
        
    }
    
    

}

