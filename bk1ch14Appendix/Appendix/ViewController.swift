

import UIKit
import WebKit
import AudioToolbox
import ImageIO
import AVFoundation


@objc enum Star : Int {
    case blue
    case white
    case yellow
    case red
}

struct Bird {}

/*
 despite the Swift 3 small-letter convention, this is rendered as:
 
 typedef SWIFT_ENUM(NSInteger, Star) {
   StarBlue = 0,
   StarWhite = 1,
   StarYellow = 2,
   StarRed = 3,
 };

 */

public class MyClass {
    var name : String?
    var timer : Timer?
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1,
            target: self, selector: #selector(timerFired),
            userInfo: nil, repeats: true)
    }
    @objc func timerFired(_ t:Timer) { // will crash without @objc; #selector prevents with compiler error
        print("timer fired")
        print("invalidating timer")
        self.timer?.invalidate()
    }
}

class MyOtherClass : NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        decisionHandler(.allow)
    }
}

@objc class MyClass2 : NSObject {
    
}

@objcMembers class MyThirdClass {
    @nonobjc func testing() {
        
    }
}

struct Pair {
    let x : Int
    let y : Int
}

class Womble : NSObject { // Objective-C sees this automatically
    override init() {
        super.init()
    }
}

@objc protocol Proto {
    var protovar : String {get}
}

// @objc class Warble {} // illegal

class Warble : Proto {
    @objc var protovar: String = "howdy" // legal, but no automatic exposure because Warble is not exposed
}

struct Person {
    let firstName : String
    let lastName: String
}

class ViewController: UIViewController, Proto { // Objective-C can see this because it comes from NSObject
    
    var myOptionalInt : Int? // Objective-C cannot be made to see this
    
    var myClass = MyClass() // Objective-C cannot be made to see this
    
    @objc var myThing = Thing() // Objective-C can see this only if marked with @objc
    
    @objc var myWomble = Womble() // Objective-C can see this only if marked with @objc
    
    var protovar = "howdy" // Objective-C can see this because it fulfills an @objc protocol
    
    init() { // Objective-C can see this because it's an override of an Objective-C method
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder:NSCoder) { // Objective-C can see this because it implements an Objective-C protocol
        super.init(coder:coder)
    }
    
    typealias MyStringExpecter = (String) -> ()
    class StringExpecterHolder : NSObject {
        var f : MyStringExpecter!
    }

    func blockTaker(_ f:()->()) {}
    // - (void)blockTaker:(void (^ __nonnull)(void))f;
    func functionTaker(_ f:@convention(c)() -> ()) {}
    // - (void)functionTaker:(void (* __nonnull)(void))f;
    
    // overloading while hiding
    @nonobjc func dismissViewControllerAnimated(_ flag: Int, completion: (() -> ())?) {}
    
    func testVisibility1(what:Int) {}
    func testVisibility2(what:MyClass) {}
    
    let lm = NSLayoutManager()
    
    override func viewDidLoad() { // Objective-C can see this because it's an override of an Objective-C method
        super.viewDidLoad()
        
        do {
            let t = Thing()
            t.take1Bool(true) // no need for ObjCBool here; we just supply a Swift Bool
            // but you can still need an ObjCBool, as here
            var isDir : ObjCBool = false
            let ok = FileManager.default.fileExists(atPath: "yoho", isDirectory: &isDir)
            
            let ns = "howdy" as NSString
            let s = ns as String
        }
        
        do {
            let t = Thing()
            t.take1Number(1) // legal
            let i = UInt8(1)
            // t.take1Number(i) // nope, still can't do that
            t.take1Number(i as NSNumber) // but you can do that!
            
            let n = i as NSNumber
            let ii = n as! UInt8
        }
        
        do {
            // proving that Swift structs don't get the zeroing initializer
            // let p = Pair()
            let pp = CGPoint()
            let v = pp as NSValue // legal
            let pp2 = v as! CGPoint
            
            let t = Thing()
            // t.take1Value(pp) // nope
            t.take1Value(pp as NSValue)
        }
        
        do {
            let t = Thing()
            let arr = [1,2,3]
            t.take1Array(arr)
            t.take1Array(arr as [NSNumber]) // same
            let arr2 = [UInt8(1)]
            t.take1Array(arr2)
            let arr3 = [CGPoint()]
            t.take1Array(arr3)
            let arr4 = [Data([1,2,3]) as NSData]
            t.take1Array(arr4)
            
        }
        
        // example for the Any section
        do {
            
            let t = Thing()
            
            t.take1id("howdy")
            t.take1id(1)
            t.take1id(CGRect())
            t.take1id(Date())
            t.take1id(Bird())
            

        }
        
        do { // passing to an Any (id) to see how we cross the bridge
            let t = Thing()
            t.take1id("howdy")
            t.take1id(1)
            t.take1id(UInt8(1))
            t.take1id(CGPoint())
            t.take1id([1,2,3]) // SwiftDeferredNSArray
            t.take1id([1,2,3] as [NSNumber]) // ContiguousArrayStorage
            let arr : [Int?] = [1, nil, 2]
            t.take1id(arr)
            let set : Set<Int> = [1,2,3]
            t.take1id(set)
            // okay, so for sets the matter doesn't arise, because it isn't hashable
//            let set2 : Set<CGPoint> = [.zero]
//            t.take1id(set2)

            t.take1id(["hey":"ho"])
            t.take1id(["hey":"ho"] as NSDictionary)
            t.take1id(Date())
            t.take1id(IndexPath(row: 1, section: 1))
            
            t.take1id(Person(firstName: "Matt", lastName: "Neuburg"))
            // t.take1id(MyClass()) // crash!
            // the crash is not because a MyClass can't cross the bridge...
            // but because my Objective-C code is attempting to look in the box by logging
            t.take1id(MyClass()) // they fixed the crash after I filed a bug
            // t.take1id2(MyClass()) // solves the problem; we can call `class` on this thing at least
            t.take1id(MyClass2()) // objc
        }
        
        // another way of looking at the question
        do {
            func test(_ x:Any) {
                let lay = CALayer()
                lay.setValue(x, forKey:"test")
                let xx = lay.value(forKey:"test")!
                print(type(of:xx))
            }
            // these all cross the bridge except as marked
            test("howdy")
            test(1)
            test(UInt8(1))
            test(CGPoint())
            test([1,2,3]) // doesn't cross bridge for Ints
            test([1,2,3] as [NSNumber])
            test(["hey":1]) // doesn't cross bridge for 1
            test(["hey":1] as NSDictionary)
            test(Date())
            test(IndexPath(row: 1, section: 1))
            test(Person(firstName: "Matt", lastName: "Neuburg")) // hidden in a SwiftValue
            test(MyClass()) // solves the problem; we can call `class` on this thing at least

            
        }
        
        do {
        
            let cs = ("hello" as NSString).utf8String
            let csArray = "hello".utf8CString
            if let cs2 = "hello".cString(using: .utf8) { // [CChar]
                let ss = String(validatingUTF8: cs2)
                print(ss as Any)
            }
            
            "hello".withCString {
                var cs = $0 // UnsafePointer<Int8>
                while cs.pointee != 0 {
                    print(cs.pointee)
                    cs += 1 // or: cs = cs.successor()
                }
            }
            
//            _ = q
//            _ = qq
            _ = cs
            
        }
        
        do {
            let da = kDead
            print(da)
            
            setState(kDead)
            setState(kAlive)
            setState(State(rawValue:2)) // Swift can't stop you
            
            var anim = UIStatusBarAnimation.fade
            anim = .slide
            anim = .none // this is a case where .none still exists separately
            
            self.view.autoresizingMask = .flexibleWidth
            self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // self.view.autoresizingMask = .none
        }
        
        do {
            let lastCharRange = 0
            
            let property = self.lm.propertyForGlyph(at:lastCharRange)
//            let mask1 = property.rawValue
//            let mask2 = NSLayoutManager.GlyphProperty.controlCharacter.rawValue
//            let ok = mask1 & mask2 != 0 // can't say .contains here
            let ok2 = property.contains(.controlCharacter) // they fixed it!
        }
        
        do {
            // try? AVAudioSession.sharedInstance().setCategory(.ambient)
            try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        }
        
        do {
            // structs have suppressed the functions
            // CGPoint.make(CGFloat(0), CGFloat(0))
            let ok = CGPoint(x:1, y:2).equalTo(CGPoint(x:1.0, y:2.0))
            let z = CGPoint.zero
        }
        
        do {
            let c = UIColor.purple
            
            var r : CGFloat = 0
            var g : CGFloat = 0
            var b : CGFloat = 0
            var a : CGFloat = 0
            c.getRed(&r, green: &g, blue: &b, alpha: &a)

        }
        
        do {
            UIGraphicsBeginImageContext(CGSize(width:200,height:200))
            let c = UIGraphicsGetCurrentContext()!
            let arr = [CGPoint(x:0,y:0),
                CGPoint(x:50,y:50),
                CGPoint(x:50,y:50),
                CGPoint(x:0,y:100),
            ]
            c.__strokeLineSegments(between: arr, count: 4)
            UIGraphicsEndImageContext()
        }
        
        do {
            UIGraphicsBeginImageContext(CGSize(width:200,height:200))
            let c = UIGraphicsGetCurrentContext()!
            // see https://github.com/apple/swift-evolution/blob/master/proposals/0184-unsafe-pointers-add-missing.md
            let arr = UnsafeMutablePointer<CGPoint>.allocate(capacity:4)
            defer {
                arr.deinitialize(count:4)
                arr.deallocate()
            }
            arr[0] = CGPoint(x:0,y:0)
            arr[1] = CGPoint(x:50,y:50)
            arr[2] = CGPoint(x:50,y:50)
            arr[3] = CGPoint(x:0,y:100)
            c.__strokeLineSegments(between: arr, count:4)
            let im = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.addSubview(UIImageView(image:im)) // just checking :)
        }
        
        do {
            let col = UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0)
            if let comp = col.cgColor.__unsafeComponents,
                let sp = col.cgColor.colorSpace,
                sp.model == .rgb {
                let red = comp[0]
                let green = comp[1]
                let blue = comp[2]
                let alpha = comp[3]
                
                print(red, green, blue, alpha)
            }
        }
        
        do {
//            struct Arrow {
//                static let ARHEIGHT : CGFloat = 20
//            }
            let arrowHeight : CGFloat = 20
            let rect = CGRect(x: 10, y: 10, width: 100, height: 100)
            var arrow = CGRect.zero
            var body = CGRect.zero
            rect.__divided(
                slice: &arrow, remainder: &body, atDistance: arrowHeight, from: .minYEdge)
            do {
                let (arrow, body) = rect.divided(atDistance: arrowHeight, from: .minYEdge)
            }

        }
        var which : Bool {return false}
        if which {
            let sndurl = Bundle.main.url(forResource:"test", withExtension: "aif")!
            var snd : SystemSoundID = 0
            AudioServicesCreateSystemSoundID(sndurl as CFURL, &snd)
        }
        
        do {
            class MyClass2 /*: NSObject*/ {
                var name : String?
            }
            let c = MyClass2()
            c.name = "cool"
            let arr = [c]
            let arr2 = arr as NSArray
            let name = (arr2[0] as? MyClass2)?.name
            print(name as Any)
        }
        
        do {
            let lay = CALayer()
            
            let p = Person(firstName: "Matt", lastName: "Neuburg")
            lay.setValue(p, forKey: "person")
            // ... time passes ...
            if let p2 = lay.value(forKey: "person") as? Person {
                print(p2.firstName, p2.lastName) // Matt Neuburg
            }
            
            let mc = MyClass()
            lay.setValue(mc, forKey:"myclass")
            if let mc3 = lay.value(forKey:"myclass") as? MyClass {
                print("all is well")
            }
        }
        
        do {
            let lay = CALayer()
            class MyClass2 /*: NSObject*/ {
                var name : String?
            }
            let c = MyClass2()
            c.name = "cool"
            lay.setValue(c, forKey: "c")
            let name = (lay.value(forKey: "c") as? MyClass2)?.name
            print(name as Any)
        }
        
        do {
            let lay = CALayer()
            lay.setValue(CGPoint(x:100,y:100), forKey: "point")
            lay.setValue([CGPoint(x:100,y:100)], forKey: "pointArray")
            let point = lay.value(forKey:"point")
            let pointArray = lay.value(forKey:"pointArray")
            print(type(of:point!))
            print(type(of:pointArray!))
        }
        
        do {
            let s = "hello"
            let s2 = s.replacingOccurrences(of: "ell", with:"ipp")
            // s2 is now "hippo"
            print(s2)
        }
        
        do {
            let b = UIButton()
            // I don't understand the warnings in the next two lines; bug?
            b.addTarget(self, action: Selector("doNewGame:"), for: .touchUpInside)
            b.addTarget(self, action: "doNewGame:", for: .touchUpInside)
            b.addTarget(self, action: #selector(doNewGame), for: .touchUpInside)

        }
        
        do {
            let sel = #selector(doButton)
            print(sel)
            let sel2 = #selector(makeHash as ([String]) -> ())
            print(sel2)
            let sel3 = #selector(makeHash as ([Int]) -> ())
            print(sel3)
            
            let arr = NSArray(objects:1,2,3)
        }
        
        do {
            // hold my beer and watch _this_!
            // big cleanup here
            
            let arr = ["Mannyz", "Moey", "Jackx"]

            func sortByLastCharacter(_ s1:Any, _ s2:Any) -> ComparisonResult { // *
                let c1 = String((s1 as! String).last!)
                let c2 = String((s2 as! String).last!)
                return c1.compare(c2)
            }
            let arr2 = (arr as NSArray).sortedArray(comparator:sortByLastCharacter)
            print(arr2)
            let arr3 = (arr as NSArray).sortedArray { s1, s2 in
                let c1 = String((s1 as! String).last!)
                let c2 = String((s2 as! String).last!)
                return c1.compare(c2)
            }
            print(arr3)
        }

        print("testing timer")
        self.testTimer()
        
        do {
            let grad = CAGradientLayer()
            grad.colors = [
                UIColor.lightGray.cgColor,
                UIColor.lightGray.cgColor,
                UIColor.blue.cgColor
            ]

        }
        
        do {
            func f (_ s:String) {print(s)}
            // let thing = f as! AnyObject // crash
            let holder = StringExpecterHolder()
            holder.f = f
            let lay = CALayer()
            lay.setValue(holder, forKey:"myFunction")
            let holder2 = lay.value(forKey: "myFunction") as! StringExpecterHolder
            holder2.f("testing")
        }
        
        do {
            // let mas = NSMutableAttributedString()
            let f = UIFont(name: "Helvetica", size: 12)!
            let mas = NSMutableAttributedString(string: "howdy", attributes: [.font : f])
            let r = NSMakeRange(0,1)
            mas.enumerateAttribute(.font, in: r) { // *
                value, r, stop in
                if let value = value as? UIFont, value == f  {
                    print("got the font")
                    // ...
                    stop.pointee = true
                }
            }

        }
        
        
        self.reportSelectors()
        
        do {
            let t = Thing2<NSString>()
            t.giveMeAThing("howdy")
        }
        
    }
    
    func inverting(_:ViewController) -> ViewController {
        return ViewController()
    }
    
    @IBAction func doButton(_ sender: Any?) {
    
    }
    
    // lots of new objc explicit here
    
    @objc func makeHash(ingredients stuff:[String]) {
        
    }
    
    @objc func makeHash(of stuff:[Int]) {
        
    }
    
    override func prepare(for war: UIStoryboardSegue, sender trebuchet: Any?) {
        // ...
    }
    
    override func canPerformAction(_ action: Selector,
        withSender sender: Any?) -> Bool {
            if action == #selector(undo) {
            }
            return true
    }
    
    @objc func undo () {}
    
    func testVariadic(_ stuff: Int ...) {}
    
    func testDefault(_ what: Int = 42) {}


    var myclass = MyClass() // Objective-C can't see this
    func myFunc(_ m:MyClass) {} // Objective-C can't see this
    // trying to mark either of those @objc will fail
    func testTimer() {
        self.myclass.startTimer()
    }

    @objc func sayHello() -> String // "sayHello"
    { return "ha"}
    
    @objc func say(_ s:String) // "say:"
    {}
    
    @objc func say(string s:String) // "sayWithString:"
    {}
    
    @objc func say(_ s:String, times n:Int) // "say:times:"
    {}

    @objc func say(of s:String, loudly:Bool)
    {}
    
    func reportSelectors() {
        print(#selector(self.sayHello))
        print(#selector(self.say(_:)))
        print(#selector(self.say(string:)))
        print(#selector(self.say(_:times:)))
        print(#selector(self.say(of:loudly:)))
    }

    @objc func doNewGame(_ sender:Any) { print("do new game") }

}

extension ViewController : AVCapturePhotoCaptureDelegate {
    
    // this is just so I can show a raw buffer
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto sampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let prev = previewPhotoSampleBuffer {
            if let buff = CMSampleBufferGetImageBuffer(prev) {
                // buff is a CVImageBuffer
                if let baseAddress = CVPixelBufferGetBaseAddress(buff) {
                    // baseAddress is an UnsafeMutableRawPointer
                    let addrptr = baseAddress.assumingMemoryBound(to: UInt8.self)
                    // addrptr is an UnsafeMutablePointer<UInt8>
                    let addr = addrptr.pointee // now we have a UInt8
                    _ = addr
                }
            }
                
        }
    }
}


