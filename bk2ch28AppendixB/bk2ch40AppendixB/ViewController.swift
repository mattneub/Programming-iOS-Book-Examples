

import UIKit

func delay(_ delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}

extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}

extension CGSize {
    func sizeByDelta(dw:CGFloat, dh:CGFloat) -> CGSize {
        return CGSize(self.width + dw, self.height + dh)
    }
}

func dictionaryOfNames(_ arr:UIView...) -> [String:UIView] {
    var d = [String:UIView]()
    for (ix,v) in arr.enumerated() {
        d["v\(ix+1)"] = v
    }
    return d
}

extension NSLayoutConstraint {
    class func reportAmbiguity (_ v:UIView?) {
        var v = v
        if v == nil {
            v = UIApplication.shared().keyWindow
        }
        for vv in v!.subviews {
            print("\(vv) \(vv.hasAmbiguousLayout())")
            if vv.subviews.count > 0 {
                self.reportAmbiguity(vv)
            }
        }
    }
    class func listConstraints (_ v:UIView?) {
        var v = v
        if v == nil {
            v = UIApplication.shared().keyWindow
        }
        for vv in v!.subviews {
            let arr1 = vv.constraintsAffectingLayout(for:.horizontal)
            let arr2 = vv.constraintsAffectingLayout(for:.vertical)
            NSLog("\n\n%@\nH: %@\nV:%@", vv, arr1, arr2);
            if vv.subviews.count > 0 {
                self.listConstraints(vv)
            }
        }
    }
}

func imageOfSize(_ size:CGSize, _ opaque:Bool = false, _ closure: @noescape () -> ())
    -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
        closure()
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
}

extension UIView {
    class func animate(times:Int,
                       duration dur: NSTimeInterval,
                       delay del: NSTimeInterval,
                       options opts: UIViewAnimationOptions,
                       animations anim: () -> Void,
                       completion comp: ((Bool) -> Void)?) {
        func helper(_ t:Int,
                    _ dur: NSTimeInterval,
                    _ del: NSTimeInterval,
                    _ opt: UIViewAnimationOptions,
                    _ anim: () -> Void,
                    _ com: ((Bool) -> Void)?) {
            UIView.animate(withDuration: dur,
                           delay: del, options: opt,
                           animations: anim, completion: {
                            done in
                            if com != nil {
                                com!(done)
                            }
                            if t > 0 {
                                delay(0) {
                                    helper(t-1, dur, del, opt, anim, com)
                                }
                            }
            })
        }
        helper(times-1, dur, del, opts, anim, comp)
    }
}

extension Array {
    mutating func remove(at ixs:[Int]) -> () {
        for i in ixs.sorted(isOrderedBefore:>) {
            self.remove(at:i)
        }
    }
}

func lend<T where T:NSObject> (closure: @noescape (T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class Wrapper<T> {
    let p:T
    init(_ p:T){self.p = p}
}



class ViewController: UIViewController {
    
    @IBOutlet weak var v: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delay(0.4) {
            // do something here
        }
        
        let d = dictionaryOfNames(self.view, self.v)
        print(d)
        
        NSLayoutConstraint.reportAmbiguity(self.view)
        NSLayoutConstraint.listConstraints(self.view)
        
        
        let _ = imageOfSize(CGSize(100,100)) {
            let con = UIGraphicsGetCurrentContext()!
            con.addEllipse(inRect: CGRect(0,0,100,100))
            con.setFillColor(UIColor.blue().cgColor)
            con.fillPath()
        }
        
        let _ = imageOfSize(CGSize(100,100), true) {
            let con = UIGraphicsGetCurrentContext()!
            con.addEllipse(inRect: CGRect(0,0,100,100))
            con.setFillColor(UIColor.blue().cgColor)
            con.fillPath()
        }

        
        let opts = UIViewAnimationOptions.autoreverse
        let xorig = self.v.center.x
        UIView.animate(times:3, duration:1, delay:0, options:opts, animations:{
            self.v.center.x += 100
            }, completion:{
                _ in
                self.v.center.x = xorig
        })
        
        var arr = [1,2,3,4]
        arr.remove(at:[0,2])
        print(arr)


        let content = NSMutableAttributedString(string:"Ho de ho")
        content.addAttribute(NSParagraphStyleAttributeName,
            value:lend {
                (para:NSMutableParagraphStyle) in
                para.headIndent = 10
                para.firstLineHeadIndent = 10
                para.tailIndent = -10
                para.lineBreakMode = .byWordWrapping
                para.alignment = .center
                para.paragraphSpacing = 15
            }, range:NSMakeRange(0,1))

        
        let s = "howdy"
        let w = Wrapper(s)
        let thing : AnyObject = w
        let realthing = (thing as! Wrapper).p as String
        print(realthing)

        
    }


}

