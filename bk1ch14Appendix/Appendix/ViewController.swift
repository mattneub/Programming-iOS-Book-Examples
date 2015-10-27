

import UIKit


@objc enum Star : Int {
    case Blue
    case White
    case Yellow
    case Red
}

class MyClass {
    var timer : NSTimer?
    func startTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1,
            target: self, selector: "timerFired:",
            userInfo: nil, repeats: true)
    }
    @objc func timerFired(t:NSTimer) { // will crash without @objc
        print("timer fired")
        self.timer?.invalidate()
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

            let cs = "hello".UTF8String // UnsafePointer<Int8>
            if let cs2 = "hello".cStringUsingEncoding(NSUTF8StringEncoding) { // [CChar]?
                let ss = String.fromCString(cs2)
                print(ss)
            }
            
            let _ : Void = "hello".withCString {
                var cs = $0
                while cs.memory != 0 {
                    print(cs.memory)
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
            
            self.view.autoresizingMask = .FlexibleWidth
            self.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
        }
        
        do {
            UIGraphicsBeginImageContext(CGSizeMake(200,200))
            let c = UIGraphicsGetCurrentContext()!
            let arr = [CGPoint(x:0,y:0),
                CGPoint(x:50,y:50),
                CGPoint(x:50,y:50),
                CGPoint(x:0,y:100),
            ]
            CGContextStrokeLineSegments(c, arr, 4)
            UIGraphicsEndImageContext()
        }
        
        do {
            UIGraphicsBeginImageContext(CGSizeMake(200,200))
            let c = UIGraphicsGetCurrentContext()!
            let arr = UnsafeMutablePointer<CGPoint>.alloc(4)
            arr[0] = CGPoint(x:0,y:0)
            arr[1] = CGPoint(x:50,y:50)
            arr[2] = CGPoint(x:50,y:50)
            arr[3] = CGPoint(x:0,y:100)
            CGContextStrokeLineSegments(c, arr, 4)
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.view.addSubview(UIImageView(image:im)) // just checking :)
        }
        
        do {
            let col = UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0)
            let comp = CGColorGetComponents(col.CGColor)
            
            if let sp = CGColorGetColorSpace(col.CGColor) {
                if CGColorSpaceGetModel(sp) == .RGB {
                    let red = comp[0]
                    let green = comp[1]
                    let blue = comp[2]
                    let alpha = comp[3]
                    
                    print(red, green, blue, alpha)
                }
            }
        }
        
        do {
            // hold my beer and watch _this_!
            
            let arr = ["Manniez", "Moey", "Jackx"]
            func sortByLastCharacter(s1:AnyObject,
                _ s2:AnyObject, _ context: UnsafeMutablePointer<Void>) -> Int {
                    let c1 = (s1 as! String).characters.last
                    let c2 = (s2 as! String).characters.last
                    return ((String(c1)).compare(String(c2))).rawValue
            }
            let arr2 = (arr as NSArray).sortedArrayUsingFunction(sortByLastCharacter, context: nil)
            print(arr2)
            let arr3 = (arr as NSArray).sortedArrayUsingFunction({
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
                UIColor.lightGrayColor().CGColor,
                UIColor.lightGrayColor().CGColor,
                UIColor.blueColor().CGColor
            ]

        }
        
        do {
            func f (s:String) {print(s)}
            // let thing = f as! AnyObject // crash
            let holder = StringExpecterHolder()
            holder.f = f
            let lay = CALayer()
            lay.setValue(holder, forKey:"myFunction")
            let holder2 = lay.valueForKey("myFunction") as! StringExpecterHolder
            holder2.f("testing")
        }
        
        do {
            let mas = NSMutableAttributedString()
            let r = NSMakeRange(0,0) // not really, just making sure we compile
            mas.enumerateAttribute("HERE", inRange: r, options: []) {
                value, r, stop in
                if let value = value as? Int where value == 1  {
                    // ...
                    stop.memory = true
                }
            }

        }
        
    }

    var myclass = MyClass()
    func testTimer() {
        self.myclass.startTimer()
    }



}

