

import UIKit

class MyView: UIView {
    
    @IBInspectable var name : String?
    // new Xcode 6 feature, edit properties in Attributes inspector instead of Runtime Attributes
    
    // let's test
    // Apple claims:
    // Bool, number, String, CGRect, CGPoint, CGSize, UIColor, NSRange, or an Optional
    @IBInspectable var myBool : Bool = false
    @IBInspectable var myString : String = "howdy"
    @IBInspectable var myInt : Int = 1
    @IBInspectable var myDouble : Double = 1
    @IBInspectable var myRect : CGRect = .zero
    @IBInspectable var myPoint : CGPoint = .zero
    @IBInspectable var mySize : CGSize = .zero
    @IBInspectable var myColor : UIColor? = .red
    @IBInspectable var myImage : UIImage?
    @IBInspectable var myRange : NSRange = NSMakeRange(0,10)
    // Apple _claims_ that ranges work, but the above doesn't compile
    @IBInspectable var someView : UIView? // compiles but doesn't work
    
    override var description : String {
        return super.description + "\n" + (self.name ?? "noname")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.preservesSuperviewLayoutMargins = true // so that we inherit margin changes
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        print("\(self)\n\(#function)\n")
    }
    
    // layout gets an extra cycle, I've no idea why
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of:layer) // essential, we get wrong layout otherwise
        print("\(self)\n\(#function)\n")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews() // not essential, but removing makes no difference
        print("\(self)\n\(#function)\n")
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        print("\(self)\n\(#function)\n")
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        print("\(self)\n\(#function)\n")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // super.traitCollectionDidChange(previousTraitCollection)
        print("\(self)\n\(#function)\n")
//        let prev : UITraitCollection? = previousTraitCollection
//        if prev == nil {
//            print("nil")
//        }
//        let none = "none"
//        print("old: \(previousTraitCollection ?? none)\n")
    }
    
    override class var layerClass : AnyClass {
        return MyLoggingLayer.self
    }
}

class MyLoggingLayer : CALayer {
    override func layoutSublayers() {
        super.layoutSublayers() // essential, we get wrong layout otherwise
        guard let del = self.delegate else {return}
        print("layer of \(del)\n\(#function)\n")
    }
}
