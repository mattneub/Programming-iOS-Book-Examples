

import UIKit

// no longer needed, they supplied a native shuffle method
/*
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
 */

// I don't like this implementation any more
/*
extension Array {
    mutating func remove (at ixs:Set<Int>) -> () {
        // for i in ixs.sorted().reversed() { // this might be clearer
        for i in ixs.sorted(by:>) { // required param label
            self.remove(at:i)
        }
    }
}
 */

extension String {
    func range(_ start:Int, _ count:Int) -> Range<String.Index> {
        let i = self.index(start >= 0 ?
            self.startIndex :
            self.endIndex, offsetBy: start)
        let j = self.index(i, offsetBy: count)
        return i..<j
    }
}


extension CGRect {
    var center : CGPoint {
        return CGPoint(x:self.midX, y:self.midY)
    }
}

extension CGSize {
    func withDelta(dw:CGFloat, dh:CGFloat) -> CGSize {
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

// this, incredibly, is legal
// won't break your storyboard buttons but you can no longer call `sendAction` manually
public extension UIButton {
    override open func sendActions(for controlEvents: UIControl.Event) {}
}

// okay, but the problem solved by the above can now be solved another way,
// because we have key value types? need to check that

// Swift 2 style
func enumerated<T:Sequence>(_ seq:T) -> EnumeratedSequence<T> {
    return seq.enumerated()
}


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

// looks like this syntax compiles only by a mistake; see https://stackoverflow.com/questions/50913244/swift-protocol-with-where-self-clause

protocol P where Self : UIView {}
// protocol PP where Self : String {} // no, has to be a protocol or string
// protocol PPP where Self == String {} // no, has to be colon I think
protocol PPPP where Self : Sequence {} // okay! so it can be protocol, even a generic protocol

// a few more tests of this syntax:
// protocol PPPPP where Self : UIView {} // illegal in simple Swift 3, but legal in Swift 3.3
protocol PPPPPP {}
extension PPPPPP where Self : UIView {} // legal in Swift 3!

// however, the problem with that syntax is: how would you use it?
// I guess the idea is that you're going to write an extension with a where clause
// and you want to ensure that the protocol isn't accidentally adopted elsewhere

// extension Dog : P {} // illegal
extension UITableView : P {} // ok
let x = [P]() // ok, proving that P is not generic

protocol FlierZZZ {
    func flockTogetherWith(_ f:Self)
}
// let xxx = [FlierZZZ]() // error, FlierZZZ _is_ generic

func myMin<T:Comparable>(_ things:T...) -> T {
    var minimum = things.first!
    for item in things.dropFirst() {
        if item < minimum {
            minimum = item
        }
    }
    return minimum
}


extension Array where Element:Comparable {
    func myMin() -> Element? {
        var minimum = self.first
        for item in self.dropFirst() {
            if item < minimum! {
                minimum = item
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
    @IBOutlet var button : UIButton!
    
    @IBAction func doButton(_ sender: Any) {
        print("button")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.button.sendActions(for: .touchUpInside)
        
        let s = "abcdefg"
        let r1 = s.range(2,2)
        let r2 = s.range(-3,2)
        print(s[r1]) // cd
        print(s[r2]) // ef

        
//        var arr = ["Manny", "Moe", "Jack"]
//        arr.remove(at: [0,2])
//        print(arr) // ["Moe"]
        
//        struct Person { let name: String }
//        var arr2 = [Person(name:"Manny"), Person(name:"Moe"), Person(name:"Jack")]
//        let marr2 = NSMutableArray(array: arr2)
//        marr2.removeObjects(at:IndexSet([0,2]))
//        arr2 = marr2 as! [Person]
//        print(arr2)
        
        let seq = [1,2,3]
        for what in enumerated(seq) { print(what) }
        
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
        print(m as Any)
        // let dd = [Digit(number:12), Digit(number:42)].min() // compile error
        print([4,1,5].myMin() as Any)
        
        
    }
    
    

}

