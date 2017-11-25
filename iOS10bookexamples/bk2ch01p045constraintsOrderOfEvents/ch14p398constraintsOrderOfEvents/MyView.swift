

import UIKit

class MyView: UIView {
    
    @IBInspectable var name : String?
    // new Xcode 6 feature, edit properties in Attributes inspector instead of Runtime Attributes
    
    // let's test
    // Apple claims:
    // Bool, number, String, CGRect, CGPoint, CGSize, UIColor, NSRange, or an Optional
    @IBInspectable var myBool : Bool = false
    @IBInspectable var myString : String = "howdy"
    @IBInspectable var myInt : Int? = 1
    @IBInspectable var myDouble : Double? = 1
    @IBInspectable var myRect : CGRect? = .zero
    @IBInspectable var myPoint : CGPoint? = .zero
    @IBInspectable var mySize : CGSize? = .zero
    @IBInspectable var myColor : UIColor? = .red
    @IBInspectable var myImage : UIImage?
//    @IBInspectable var myRange : Range<Int>? = 1...3 // nope
//    @IBInspectable var someView : UIView? // nope
    
    override var description : String {
        return super.description + "\n" + (self.name ?? "noname")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        print("\(self)\n\(#function)\n")
    }
    
    // gets an extra cycle, I've no idea why
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of:layer)
        print("\(self)\n\(#function)\n")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        super.layoutSublayers()
        guard let del = self.delegate else {return}
        print("layer of \(del)\n\(#function)\n")
    }
}
