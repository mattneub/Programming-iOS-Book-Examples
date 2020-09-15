

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
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
    func withDelta(dw:CGFloat, dh:CGFloat) -> CGSize {
        return CGSize(self.width + dw, self.height + dh)
    }
}

extension String {
    func range(_ start:Int, _ count:Int) -> Range<String.Index> {
        let i = self.index(start >= 0 ?
            self.startIndex :
            self.endIndex, offsetBy: start)
        let j = self.index(i, offsetBy: count)
        return i..<j
    }
    func nsRange(_ start:Int, _ count:Int) -> NSRange {
        return NSRange(self.range(start,count), in:self)
    }
}

extension Array where Element:UIView {
    func dictionaryOfNames() -> [String:UIView] {
        var d = [String:UIView]()
        for (ix,v) in self.enumerated() {
            d["v\(ix+1)"] = v
        }
        return d
    }
}

extension UIView {
    func reportAmbiguity(filtering:Bool = false) {
        let has = self.hasAmbiguousLayout
        if has || !filtering {
            print(self, has)
        }
        for sub in self.subviews {
            sub.reportAmbiguity(filtering:filtering)
        }
    }
}

extension UIView {
    func listConstraints(recursing:Bool = true, up:Bool = false, filtering:Bool = false) {
        let arr1 = self.constraintsAffectingLayout(for:.horizontal)
        let arr2 = self.constraintsAffectingLayout(for:.vertical)
        var arr = arr1 + arr2
        if filtering {
            arr = arr.filter{
                $0.firstItem as? UIView == self ||
                    $0.secondItem as? UIView == self }
        }
        if !arr.isEmpty {
            print(self); arr.forEach { print($0) }; print()
        }
        guard recursing else { return }
        if !up { // down
            for sub in self.subviews {
                sub.listConstraints(up:up)
            }
        } else { // up
            self.superview?.listConstraints(up:up)
        }
    }
}


// extension NSLayoutConstraint.Priority {}
// no longer needed
/*
extension UILayoutPriority {
    static func +(lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
        let raw = lhs.rawValue + rhs
        return UILayoutPriority(rawValue:raw)
    }
}
*/

func lend<T> (_ closure: (T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}

func imageOfSize(_ size:CGSize, opaque:Bool = false, closure: () -> ()) -> UIImage {
    if #available(iOS 10.0, *) {
        let f = UIGraphicsImageRendererFormat.default()
        f.opaque = opaque
        let r = UIGraphicsImageRenderer(size: size, format: f)
        return r.image {_ in closure()}
    } else {
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
        closure()
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
}


extension UIView {
    class func animate(times:Int,
                       duration dur: TimeInterval,
                       delay del: TimeInterval,
                       options opts: UIView.AnimationOptions,
                       animations anim: @escaping () -> Void,
                       completion comp: ((Bool) -> Void)?) {
        func helper(_ t:Int,
                    _ dur: TimeInterval,
                    _ del: TimeInterval,
                    _ opt: UIView.AnimationOptions,
                    _ anim: @escaping () -> Void,
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
    mutating func remove(at ixs:Set<Int>) -> () {
        for i in Array<Int>(ixs).sorted(by:>) { // odd that it can't infer <Int>
            self.remove(at:i)
        }
    }
}

extension Array {
    mutating func remove2(at ixs:Set<Int>) {
        var arr = Swift.Array(self.enumerated())
        arr.removeAll{ixs.contains($0.offset)}
        self = arr.map{$0.element}
    }
}


class Wrapper<T> {
    let p:T
    init(_ p:T){self.p = p}
}



class ViewController: UIViewController {
    
    @IBOutlet weak var v: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("%@", #function)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("%@", #function)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("%@", #function)
        
        do {
            let s = "abcdefg"
            let r1 = s.range(2,2)
            let r2 = s.range(-3,2)
            let r3 = s.nsRange(2,2)
            let r4 = s.nsRange(-3,2)
            
            print(s[r1]) // cd
            print(s[r2]) // ef
            print((s as NSString).substring(with:r3)) // cd
            print((s as NSString).substring(with:r4)) // ef

        }
        
        delay(0.4) {
            // do something here
        }
        
        let d = [self.view, self.v].dictionaryOfNames()
        print(d)
        
        self.view.reportAmbiguity()
        self.view.listConstraints()
        
        let _ = imageOfSize(CGSize(100,100)) {
            let con = UIGraphicsGetCurrentContext()!
            con.addEllipse(in: CGRect(0,0,100,100))
            con.setFillColor(UIColor.blue.cgColor)
            con.fillPath()
        }
        
        let _ = imageOfSize(CGSize(100,100), opaque:true) {
            let con = UIGraphicsGetCurrentContext()!
            con.addEllipse(in: CGRect(0,0,100,100))
            con.setFillColor(UIColor.blue.cgColor)
            con.fillPath()
        }

        
        let opts = UIView.AnimationOptions.autoreverse
        let xorig = self.v.center.x
        UIView.animate(times:3, duration:1, delay:0, options:opts, animations:{
            self.v.center.x += 100
            }, completion:{ _ in
                self.v.center.x = xorig
        })
        
        var arr = [1,2,3,4]
        arr.remove(at:[0,2])
        print(arr)

        do { // without lend
            let content = NSMutableAttributedString(string:"Ho de ho")
            let para = NSMutableParagraphStyle()
            para.headIndent = 10
            para.firstLineHeadIndent = 10
            para.tailIndent = -10
            para.lineBreakMode = .byWordWrapping
            para.alignment = .center
            para.paragraphSpacing = 15
            content.addAttribute(
                .paragraphStyle,
                value:para, range:NSMakeRange(0,1))
        }

        let content = NSMutableAttributedString(string:"Ho de ho")
        content.addAttribute(.paragraphStyle,
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

