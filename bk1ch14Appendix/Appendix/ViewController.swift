

import UIKit
import WebKit


@objc enum Star : Int {
    case blue
    case white
    case yellow
    case red
}

/*
 despite the Swift 3 small-letter convention, this is rendered as:
 
 typedef SWIFT_ENUM(NSInteger, Star) {
   StarBlue = 0,
   StarWhite = 1,
   StarYellow = 2,
   StarRed = 3,
 };

 */

class MyClass {
    var timer : NSTimer?
    func startTimer() {
        self.timer = NSTimer.scheduledTimer(timeInterval: 1,
            target: self, selector: #selector(timerFired),
            userInfo: nil, repeats: true)
    }
    @objc func timerFired(t:NSTimer) { // will crash without @objc
        print("timer fired")
        self.timer?.invalidate()
    }
}

class MyOtherClass : NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: (WKNavigationActionPolicy) -> Swift.Void) {
        decisionHandler(.allow)
    }
}

struct Pair {
    let x : Int
    let y : Int
}

class Womble : NSObject {
    override init() {
        super.init()
    }
}


class ViewController: UIViewController {
    
    typealias MyStringExpecter = (String) -> ()
    class StringExpecterHolder : NSObject {
        var f : MyStringExpecter!
    }

    func blockTaker(f:()->()) {}
    // - (void)blockTaker:(void (^ __nonnull)(void))f;
    func functionTaker(f:@convention(c)() -> ()) {}
    // - (void)functionTaker:(void (* __nonnull)(void))f;
    
    // overloading while hiding
    @nonobjc func dismissViewControllerAnimated(flag: Int, completion: (() -> Void)?) {}
    
    func say(string s:String) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            // proving that Swift structs don't get the zeroing initializer
            // let p = Pair()
            let pp = CGPoint()
        }
        
        do {
        
            // conversion of String to C string
            
            let q = dispatch_queue_create("MyQueue", nil)
            
            let s = "MyQueue"
            let qq = dispatch_queue_create(s, nil)

            let cs = "hello".utf8String // UnsafePointer<Int8>? // *
            if let cs2 = "hello".cString(using: NSUTF8StringEncoding) { // [CChar]?
                let ss = String(validatingUTF8: cs2)
                print(ss)
            }
            
            let _ : Void = "hello".withCString {
                var cs = $0
                while cs.pointee != 0 {
                    print(cs.pointee)
                    cs = cs.successor()
                }
            }
            
            _ = q
            _ = qq
            _ = cs
            
        }
        
        do {
            let da = kDead
            print(da)
            
            setState(kDead)
            setState(kAlive)
            setState(State(rawValue:2)) // Swift can't stop you
            
            self.view.autoresizingMask = .flexibleWidth
            self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
        }
        
        do {
            // structs have suppressed the functions
            // CGPoint.make(CGFloat(0), CGFloat(0))
            let ok = CGPoint(x:1, y:2).equalTo(CGPoint(x:1.0, y:2.0))
        }
        
        do {
            UIGraphicsBeginImageContext(CGSize(width:200,height:200))
            let c = UIGraphicsGetCurrentContext()!
            let arr = [CGPoint(x:0,y:0),
                CGPoint(x:50,y:50),
                CGPoint(x:50,y:50),
                CGPoint(x:0,y:100),
            ]
            c.strokeLineSegments(between: arr, count: arr.count)
            UIGraphicsEndImageContext()
        }
        
        do {
            UIGraphicsBeginImageContext(CGSize(width:200,height:200))
            let c = UIGraphicsGetCurrentContext()!
            let arr = UnsafeMutablePointer<CGPoint>(allocatingCapacity:4)
            defer {
                arr.deinitialize()
                arr.deallocateCapacity(4)
            }
            arr[0] = CGPoint(x:0,y:0)
            arr[1] = CGPoint(x:50,y:50)
            arr[2] = CGPoint(x:50,y:50)
            arr[3] = CGPoint(x:0,y:100)
            c.strokeLineSegments(between: arr, count: 4)
            let im = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.addSubview(UIImageView(image:im)) // just checking :)
        }
        
        do {
            let col = UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0)
            if let comp = col.cgColor.components, // * now Optional
                let sp = col.cgColor.colorSpace
                where sp.model == .RGB {
                let red = comp[0]
                let green = comp[1]
                let blue = comp[2]
                let alpha = comp[3]
                
                print(red, green, blue, alpha)
            }
        }
        
        do {
            struct Arrow {
                static let ARHEIGHT : CGFloat = 20
            }
            let myRect = CGRect(x: 10, y: 10, width: 100, height: 100)
            var arrow = CGRect.zero
            var body = CGRect.zero
            myRect.divide(
                slice: &arrow, remainder: &body, amount: Arrow.ARHEIGHT, edge: .minYEdge)

        }
        
        do {
            let s = "hello"
            let s2 = s.replacingOccurrences(of: "ell", with:"ipp")
            // s2 is now "hippo"
            print(s2)
        }
        
        do {
            let sel = #selector(doButton)
            print(sel)
            let sel2 = #selector(makeHash as ([String]) -> Void)
            print(sel2)
            let sel3 = #selector(makeHash as ([Int]) -> Void)
            print(sel3)
            
            let arr = NSArray(objects:1,2,3)
        }
        
        do {
            // hold my beer and watch _this_!
            
            let arr = ["Mannyz", "Moey", "Jackx"]
            func sortByLastCharacter(_ s1:AnyObject,
                _ s2:AnyObject, _ context: UnsafeMutablePointer<Void>?) -> Int { // *
                    let c1 = (s1 as! String).characters.last
                    let c2 = (s2 as! String).characters.last
                    return ((String(c1)).compare(String(c2))).rawValue
            }
            let arr2 = (arr as NSArray).sortedArray(sortByLastCharacter, context: nil)
            print(arr2)
            let arr3 = (arr as NSArray).sortedArray({
                s1, s2, context in
                let c1 = (s1 as! String).characters.last
                let c2 = (s2 as! String).characters.last
                return ((String(c1)).compare(String(c2))).rawValue
            }, context:nil)
            print(arr3)
        }

        self.testTimer()
        
        do {
            let grad = CAGradientLayer()
            grad.colors = [
                UIColor.lightGray().cgColor,
                UIColor.lightGray().cgColor,
                UIColor.blue().cgColor
            ]

        }
        
        do {
            func f (s:String) {print(s)}
            // let thing = f as! AnyObject // crash
            let holder = StringExpecterHolder()
            holder.f = f
            let lay = CALayer()
            lay.setValue(holder, forKey:"myFunction")
            let holder2 = lay.value(forKey: "myFunction") as! StringExpecterHolder
            holder2.f("testing")
        }
        
        do {
            let mas = NSMutableAttributedString()
            let r = NSMakeRange(0,0) // not really, just making sure we compile
            mas.enumerateAttribute("HERE", in: r) {
                value, r, stop in
                if let value = value as? Int where value == 1  {
                    // ...
                    stop.pointee = true
                }
            }

        }
        
    }
    
    func inverting(_:ViewController) -> ViewController {
        return ViewController()
    }
    
    @IBAction func doButton(_ sender:AnyObject?) {
    
    }
    
    func makeHash(ingredients stuff:[String]) {
        
    }
    
    func makeHash(of stuff:[Int]) {
        
    }
    
    override func prepare(for war: UIStoryboardSegue, sender trebuchet: AnyObject?) {
        // ...
    }
    
    override func canPerformAction(_ action: Selector,
        withSender sender: AnyObject!) -> Bool {
            if action == #selector(undo) {
            }
            return true
    }
    
    func undo () {}
    
    func testVariadic(_ stuff: Int ...) {}
    
    func testDefault(_ what: Int = 42) {}


    var myclass = MyClass()
    func testTimer() {
        self.myclass.startTimer()
    }



}

