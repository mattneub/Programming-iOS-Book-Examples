

import UIKit

/*
Not in the book, but I could certainly mention it as an example of how the
tracking methods are useful when subclassing an existing UIControl subclass
*/

class MySlider: UISlider {
    var bubbleView : UIView!
    weak var label : UILabel?
    let formatter : NSNumberFormatter = {
        let n = NSNumberFormatter()
        n.maximumFractionDigits = 1
        return n
    }()
    
    override func didMoveToSuperview() {
        self.bubbleView = UIView(frame: CGRectMake(0,0,100,100))
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), false, 0)
        let con = UIGraphicsGetCurrentContext()
        
        let p = UIBezierPath(roundedRect: CGRectMake(0,0,100,80), cornerRadius: 10)
        p.moveToPoint(CGPointMake(45,80))
        p.addLineToPoint(CGPointMake(50,100))
        p.addLineToPoint(CGPointMake(55,80))
        CGContextAddPath(con, p.CGPath)
        UIColor.blueColor().setFill()
        CGContextFillPath(con)
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let iv = UIImageView(image: im)
        self.bubbleView.addSubview(iv)
        
        let lab = UILabel(frame:CGRectMake(0,0,100,80))
        lab.numberOfLines = 1
        lab.textAlignment = .Center
        lab.font = UIFont(name:"GillSans-Bold", size:20)
        lab.textColor = UIColor.whiteColor()
        self.bubbleView.addSubview(lab)
        self.label = lab
        
    }
    
    override func thumbRectForBounds(bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let r = super.thumbRectForBounds(bounds, trackRect: rect, value: value)
        self.bubbleView?.frame.origin.x =
            r.origin.x + (r.size.width/2.0) - (self.bubbleView.frame.size.width/2.0)
        self.bubbleView?.frame.origin.y =
            r.origin.y - 105
        return r
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let bool = super.beginTrackingWithTouch(touch, withEvent: event)
        if bool {
            self.addSubview(self.bubbleView)
            self.label?.text = self.formatter.stringFromNumber(self.value)
        }
        return bool
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let bool = super.continueTrackingWithTouch(touch, withEvent: event)
        if bool {
            self.label?.text = self.formatter.stringFromNumber(self.value)
        }
        return bool
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        self.bubbleView?.removeFromSuperview()
        super.endTrackingWithTouch(touch, withEvent: event)
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        self.bubbleView?.removeFromSuperview()
        super.cancelTrackingWithEvent(event)
    }
    

}
