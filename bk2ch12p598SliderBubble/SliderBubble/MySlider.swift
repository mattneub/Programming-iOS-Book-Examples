

import UIKit

/*
Not in the book, but I could certainly mention it as an example of how the
tracking methods are useful when subclassing an existing UIControl subclass
*/

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



class MySlider: UISlider {
    var bubbleView : UIView!
    weak var label : UILabel?
    let formatter : NSNumberFormatter = {
        let n = NSNumberFormatter()
        n.maximumFractionDigits = 1
        return n
    }()
    
    override func didMoveToSuperview() {
        self.bubbleView = UIView(frame: CGRect(0,0,100,100))
        
        UIGraphicsBeginImageContextWithOptions(CGSize(100,100), false, 0)
        let con = UIGraphicsGetCurrentContext()!
        
        let p = UIBezierPath(roundedRect: CGRect(0,0,100,80), cornerRadius: 10)
        p.move(to: CGPoint(45,80))
        p.addLine(to: CGPoint(50,100))
        p.addLine(to: CGPoint(55,80))
        con.addPath(p.cgPath)
        UIColor.blue().setFill()
        con.fillPath()
        let im = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let iv = UIImageView(image: im)
        self.bubbleView.addSubview(iv)
        
        let lab = UILabel(frame:CGRect(0,0,100,80))
        lab.numberOfLines = 1
        lab.textAlignment = .center
        lab.font = UIFont(name:"GillSans-Bold", size:20)
        lab.textColor = UIColor.white()
        self.bubbleView.addSubview(lab)
        self.label = lab
        
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let r = super.thumbRect(forBounds:bounds, trackRect: rect, value: value)
        self.bubbleView?.frame.origin.x =
            r.origin.x + (r.size.width/2.0) - (self.bubbleView.frame.size.width/2.0)
        self.bubbleView?.frame.origin.y =
            r.origin.y - 105
        return r
    }
    
    override func beginTracking(with touch: UITouch, with event: UIEvent?) -> Bool {
        let bool = super.beginTracking(with:touch, with: event)
        if bool {
            self.addSubview(self.bubbleView)
            self.label?.text = self.formatter.string(from:self.value)
        }
        return bool
    }
    
    override func continueTracking(with touch: UITouch, with event: UIEvent?) -> Bool {
        let bool = super.continueTracking(with:touch, with:event)
        if bool {
            self.label?.text = self.formatter.string(from:self.value)
        }
        return bool
    }
    
    override func endTracking(with touch: UITouch?, with event: UIEvent?) {
        self.bubbleView?.removeFromSuperview()
        super.endTracking(with:touch, with: event)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        self.bubbleView?.removeFromSuperview()
        super.cancelTracking(with:event)
    }
    

}
