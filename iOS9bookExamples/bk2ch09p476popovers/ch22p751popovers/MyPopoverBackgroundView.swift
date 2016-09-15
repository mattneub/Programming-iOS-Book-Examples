

import UIKit

// inherits:
// @property (nonatomic, readwrite) UIPopoverArrowDirection arrowDirection
// @property (nonatomic, readwrite) CGFloat arrowOffset

class MyPopoverBackgroundView : UIPopoverBackgroundView {
    var arrOff : CGFloat
    var arrDir : UIPopoverArrowDirection
    
    static let ARBASE : CGFloat = 20
    static let ARHEIGHT : CGFloat = 20
    
    override class func wantsDefaultContentAppearance() -> Bool {
        return true // try false to see if you can find a difference...
    }
    
    override init(frame:CGRect) {
        self.arrOff = 0
        self.arrDir = .Any
        super.init(frame:frame)
        self.opaque = false
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    

    override func drawRect(rect: CGRect) {
        // WARNING: this code is sort of a cheat:
        // I should be checking self.arrowDirection and changing what I do depending on that...
        // but instead I am just *assuming* that the arrowDirection is UIPopoverArrowDirectionUp
        
        let linOrig = UIImage(named: "linen.png")!
        let capw = linOrig.size.width / 2.0 - 1
        let caph = linOrig.size.height / 2.0 - 1
        let lin = linOrig.resizableImageWithCapInsets(UIEdgeInsetsMake(caph, capw, caph, capw),resizingMode:.Tile)
        
        // draw the arrow
        // I'm just going to make a triangle filled with our linen background...
        // ...extended by a rectangle so it joins to our "pinked" corner drawing
        
        let con = UIGraphicsGetCurrentContext()!
        CGContextSaveGState(con)
        var propX = self.arrowOffset
        let limit : CGFloat = 22.0
        let maxX = rect.size.width/2.0 - limit
        if propX > maxX {
            propX = maxX
        }
        if propX < limit {
            propX = limit
        }
        let klass = self.dynamicType
        CGContextTranslateCTM(con, rect.size.width/2.0 + propX - klass.ARBASE/2.0, 0)
        CGContextMoveToPoint(con, 0, klass.ARHEIGHT)
        CGContextAddLineToPoint(con, klass.ARBASE / 2.0, 0)
        CGContextAddLineToPoint(con, klass.ARBASE, klass.ARHEIGHT)
        CGContextClosePath(con)
        CGContextAddRect(con, CGRectMake(0,klass.ARHEIGHT,klass.ARBASE,15))
        CGContextClip(con)
        lin.drawAtPoint(CGPointMake(-40,-40))
        CGContextRestoreGState(con)
        
        // draw the body, to go behind the view part of our rectangle (i.e. rect minus arrow)
        var arrow = CGRectZero
        var body = CGRectZero
        CGRectDivide(rect, &arrow, &body, klass.ARHEIGHT, .MinYEdge)
        lin.drawInRect(body)
        
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsetsMake(20,20,20,20)
    }
    
    // we are required to implement all this even though it's obvious what it needs to do
    
    override class func arrowBase() -> CGFloat {
        return self.ARBASE
    }
    
    override class func arrowHeight() -> CGFloat {
        return self.ARHEIGHT
    }
    
    override var arrowDirection : UIPopoverArrowDirection {
    get {
        return self.arrDir
    }
    set (val) {
        self.arrDir = val
    }
    }
    
    override var arrowOffset : CGFloat {
    get {
        return self.arrOff
    }
    set (val) {
        self.arrOff = val
    }
    }

}
