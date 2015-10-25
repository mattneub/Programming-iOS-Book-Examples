

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
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

func dictionaryOfNames(arr:UIView...) -> [String:UIView] {
    var d = [String:UIView]()
    for (ix,v) in arr.enumerate() {
        d["v\(ix+1)"] = v
    }
    return d
}

extension NSLayoutConstraint {
    class func reportAmbiguity (var v:UIView?) {
        if v == nil {
            v = UIApplication.sharedApplication().keyWindow
        }
        for vv in v!.subviews {
            print("\(vv) \(vv.hasAmbiguousLayout())")
            if vv.subviews.count > 0 {
                self.reportAmbiguity(vv)
            }
        }
    }
    class func listConstraints (var v:UIView?) {
        if v == nil {
            v = UIApplication.sharedApplication().keyWindow
        }
        for vv in v!.subviews {
            let arr1 = vv.constraintsAffectingLayoutForAxis(.Horizontal)
            let arr2 = vv.constraintsAffectingLayoutForAxis(.Vertical)
            NSLog("\n\n%@\nH: %@\nV:%@", vv, arr1, arr2);
            if vv.subviews.count > 0 {
                self.listConstraints(vv)
            }
        }
    }
}

func imageOfSize(size:CGSize, _ opaque:Bool = false, @noescape _ closure:() -> ())
    -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
        closure()
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
}

extension UIView {
    class func animateWithTimes(times:Int,
        duration dur: NSTimeInterval,
        delay del: NSTimeInterval,
        options opts: UIViewAnimationOptions,
        animations anim: () -> Void,
        completion comp: ((Bool) -> Void)?) {
            func helper(t:Int,
                _ dur: NSTimeInterval,
                _ del: NSTimeInterval,
                _ opt: UIViewAnimationOptions,
                _ anim: () -> Void,
                _ com: ((Bool) -> Void)?) {
                    UIView.animateWithDuration(dur,
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
    mutating func removeAtIndexes (ixs:[Int]) -> () {
        for i in ixs.sort(>) {
            self.removeAtIndex(i)
        }
    }
}

func lend<T where T:NSObject> (@noescape closure:(T)->()) -> T {
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
        
        
        let _ = imageOfSize(CGSizeMake(100,100)) {
            let con = UIGraphicsGetCurrentContext()!
            CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100))
            CGContextSetFillColorWithColor(con, UIColor.blueColor().CGColor)
            CGContextFillPath(con)
        }
        
        let _ = imageOfSize(CGSizeMake(100,100), true) {
            let con = UIGraphicsGetCurrentContext()!
            CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100))
            CGContextSetFillColorWithColor(con, UIColor.blueColor().CGColor)
            CGContextFillPath(con)
        }

        
        let opts = UIViewAnimationOptions.Autoreverse
        let xorig = self.v.center.x
        UIView.animateWithTimes(3, duration:1, delay:0, options:opts, animations:{
            self.v.center.x += 100
            }, completion:{
                _ in
                self.v.center.x = xorig
        })
        
        var arr = [1,2,3,4]
        arr.removeAtIndexes([0,2])
        print(arr)


        let content = NSMutableAttributedString(string:"Ho de ho")
        content.addAttribute(NSParagraphStyleAttributeName,
            value:lend {
                (para:NSMutableParagraphStyle) in
                para.headIndent = 10
                para.firstLineHeadIndent = 10
                para.tailIndent = -10
                para.lineBreakMode = .ByWordWrapping
                para.alignment = .Center
                para.paragraphSpacing = 15
            }, range:NSMakeRange(0,1))

        
        let s = "howdy"
        let w = Wrapper(s)
        let thing : AnyObject = w
        let realthing = (thing as! Wrapper).p as String
        print(realthing)

        
    }


}

