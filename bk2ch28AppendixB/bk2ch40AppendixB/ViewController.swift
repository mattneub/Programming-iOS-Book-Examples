

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

extension CGRect {
    func centeredRectOfSize(_ sz:CGSize) -> CGRect {
        let c = self.center
        let x = c.x - sz.width/2.0
        let y = c.y - sz.height/2.0
        return CGRect(x, y, sz.width, sz.height)
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

@objc extension UIView {
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

@objc extension UIView {
    func listConstraints(recursing:Bool = true, up:Bool = false, filtering:Bool = false) {
        let arr1 = self.constraintsAffectingLayout(for:.horizontal)
        let arr2 = self.constraintsAffectingLayout(for:.vertical)
        var arr = arr1 + arr2
        if filtering {
            arr = arr.filter {
                $0.firstItem as? UIView == self ||
                    $0.secondItem as? UIView == self }
        }
        if !arr.isEmpty {
            print(self); arr.forEach { print($0) }; print()
        }
        guard recursing else { return }
        if !up { // down
            for sub in self.subviews {
                sub.listConstraints(up:up, filtering:filtering)
            }
        } else { // up
            self.superview?.listConstraints(up:up, filtering:filtering)
        }
    }
}

@objc extension UIView {
    func constraint(withIdentifier id: String) -> NSLayoutConstraint? {
        return self.constraints.first { $0.identifier == id } ??
            self.superview?.constraint(withIdentifier: id)
    }
}

extension UIView {
    @IBInspectable var name : String? {
        get { return self.layer.name }
        set { self.layer.name = newValue }
    }
}

extension UIResponder {
    func next<T:UIResponder>(ofType: T.Type) -> T? {
        let r = self.next
        if let r = r as? T ?? r?.next(ofType: T.self) {
            return r
        } else {
            return nil
        }
    }
}

extension UIView {
    func subviews<T:UIView>(ofType WhatType:T.Type,
                            recursing:Bool = true) -> [T] {
        var result = self.subviews.compactMap {$0 as? T}
        guard recursing else { return result }
        for sub in self.subviews {
            result.append(contentsOf: sub.subviews(ofType:WhatType))
        }
        return result
    }
}

// not in the book, but maybe they should be:
// utilities for understanding an untouchable view

extension UIView {
    @objc func reportNoninteractiveSuperview() {
        if let sup = self.superview {
            if !sup.isUserInteractionEnabled {
                print(sup, "is disabled")
            } else {
                sup.reportNoninteractiveSuperview()
            }
        } else {
            print("no disabled superviews found")
        }
    }
}
extension UIView {
    @objc func reportSuperviews(filtering:Bool = true) {
        var currentSuper : UIView? = self.superview
        print("reporting on \(self)\n")
        while let ancestor = currentSuper {
            let ok = ancestor.bounds.contains(ancestor.convert(self.frame, from: self.superview))
            let report = "it is \(ok ? "inside" : "OUTSIDE") \(ancestor)\n"
            if !filtering || !ok { print(report) }
            currentSuper = ancestor.superview
        }
    }
}

// utility for shortening constraint creation, not in book
// I'm not big on this kind of thing, but this is so common it seems to need something

extension UIView {
    func pinToSuperview(_ insets:NSDirectionalEdgeInsets = .zero) {
        guard let sup = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: sup.topAnchor, constant: insets.top).isActive = true
        self.trailingAnchor.constraint(equalTo: sup.trailingAnchor, constant: -insets.trailing).isActive = true
        self.leadingAnchor.constraint(equalTo: sup.leadingAnchor, constant: insets.leading).isActive = true
        self.bottomAnchor.constraint(equalTo: sup.bottomAnchor, constant: -insets.bottom).isActive = true
    }
}

// reverse of `contains`, not in book, but I'd much rather talk this way:

extension Equatable {
    func isMember<T>(of coll:T) -> Bool where T:Collection, T.Element == Self {
        return coll.contains(self)
    }
}


extension UIControl {
    func addAction(for event: UIControl.Event,
                   handler: @escaping UIActionHandler) {
        self.addAction(UIAction(handler:handler), for:event)
    }
}

func lend<T> (_ closure: (T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
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
        arr.removeAll {ixs.contains($0.offset)}
        self = arr.map {$0.element}
    }
}

extension UIImage {
    func scaledDown(into size:CGSize) -> UIImage {
        var (targetWidth, targetHeight) = (self.size.width, self.size.height)
        var (scaleW, scaleH) = (1 as CGFloat, 1 as CGFloat)
        if targetWidth > size.width {
            scaleW = size.width/targetWidth
        }
        if targetHeight > size.height {
            scaleH = size.height/targetHeight
        }
        let scale = min(scaleW,scaleH)
        targetWidth *= scale; targetHeight *= scale
        let sz = CGSize(targetWidth, targetHeight)
        return UIGraphicsImageRenderer(size:sz).image { _ in
            self.draw(in:CGRect(origin:.zero, size:sz))
        }
    }
}


class Wrapper<T> {
    let p:T
    init(_ p:T) {self.p = p}
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
        
        //self.view.reportAmbiguity()
        self.view.listConstraints()
                
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

