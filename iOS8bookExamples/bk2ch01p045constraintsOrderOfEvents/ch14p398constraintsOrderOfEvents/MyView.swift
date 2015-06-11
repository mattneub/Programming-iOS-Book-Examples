

import UIKit

class MyView: UIView, Printable {
    
    @IBInspectable var name : String?
    // new Xcode 6 feature, edit properties in Attributes inspector instead of Runtime Attributes
    
    // let's test
    // Apple claims:
    // Bool, number, String, CGRect, CGPoint, CGSize, UIColor, NSRange, or an Optional
    @IBInspectable var myBool : Bool = false
    @IBInspectable var myString : String = "howdy"
    @IBInspectable var myInt : Int? = 1
    @IBInspectable var myDouble : Double? = 1
    @IBInspectable var myRect : CGRect? = CGRectZero
    @IBInspectable var myPoint : CGPoint? = CGPointZero
    @IBInspectable var mySize : CGSize? = CGSizeZero
    @IBInspectable var myColor : UIColor? = UIColor.redColor()
    @IBInspectable var myImage : UIImage?
    //@IBInspectable var myRange : Range<Int>? = 1...3 // nope
    //@IBInspectable var someView : UIView? // nope
    
    override var description : String {
        return super.description + "\n" + (self.name ?? "noname")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        println("\(self)\n\(__FUNCTION__)\n")
    }
    
    // gets an extra cycle, I've no idea why
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        println("\(self)\n\(__FUNCTION__)\n")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        println("\(self)\n\(__FUNCTION__)\n")
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        // super.traitCollectionDidChange(previousTraitCollection)
        println("\(self)\n\(__FUNCTION__)\n")
//        let prev : UITraitCollection? = previousTraitCollection
//        if prev == nil {
//            println("nil")
//        }
//        let none = "none"
//        println("old: \(previousTraitCollection ?? none)\n")
    }
    
    override class func layerClass() -> AnyClass {
        return MyLoggingLayer.self
    }
}

class MyLoggingLayer : CALayer {
    override func layoutSublayers() {
        super.layoutSublayers()
        println("layer of \(self.delegate)\n\(__FUNCTION__)\n")
    }
}
