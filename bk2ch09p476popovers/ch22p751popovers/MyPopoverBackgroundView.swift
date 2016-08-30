

import UIKit

// inherits:
// @property (nonatomic, readwrite) UIPopoverArrowDirection arrowDirection
// @property (nonatomic, readwrite) CGFloat arrowOffset

class MyPopoverBackgroundView : UIPopoverBackgroundView {
    static let ARBASE : CGFloat = 20
    static let ARHEIGHT : CGFloat = 20

    
    var arrOff : CGFloat
    var arrDir : UIPopoverArrowDirection
    
    
    // we are required to implement all this even though it's obvious what it needs to do
    
    override class func arrowBase() -> CGFloat {
        return self.ARBASE
    }
    
    override class func arrowHeight() -> CGFloat {
        return self.ARHEIGHT
    }
    
    override var arrowDirection : UIPopoverArrowDirection {
        get { return self.arrDir }
        set { self.arrDir = newValue }
    }
    
    override var arrowOffset : CGFloat {
        get { return self.arrOff }
        set { self.arrOff = newValue }
    }
    

    
    
    override init(frame:CGRect) {
        self.arrOff = 0
        self.arrDir = .any
        super.init(frame:frame)
        self.isOpaque = false
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override class var wantsDefaultContentAppearance : Bool {
        return true // try false to see if you can find a difference...
    }


    override func draw(_ rect: CGRect) {
        // WARNING: this code is sort of a cheat:
        // I should be checking self.arrowDirection and changing what I do depending on that...
        // but instead I am just *assuming* that the arrowDirection is UIPopoverArrowDirectionUp
        
        let linOrig = UIImage(named: "linen.png")!
        let capw = linOrig.size.width / 2.0 - 1
        let caph = linOrig.size.height / 2.0 - 1
        let lin = linOrig.resizableImage(withCapInsets:UIEdgeInsetsMake(caph, capw, caph, capw),resizingMode:.tile)
        
        
        // draw the arrow
        // I'm just going to make a triangle filled with our linen background...
        // ...extended by a rectangle so it joins to our "pinked" corner drawing
        
        var arrow : Bool {return true} // false to omit arrow, cute technique
        if arrow {
        
            let con = UIGraphicsGetCurrentContext()!
            con.saveGState()
            // clamp offset
            var propX = self.arrowOffset
            let limit : CGFloat = 22.0
            let maxX = rect.size.width/2.0 - limit
            if propX > maxX { propX = maxX }
            if propX < limit { propX = limit }
            let klass = type(of:self)
            con.translateBy(x: rect.size.width/2.0 + propX - klass.ARBASE/2.0, y: 0)
            con.move(to:CGPoint(0, klass.ARHEIGHT))
            con.addLine(to:CGPoint(klass.ARBASE / 2.0, 0))
            con.addLine(to:CGPoint(klass.ARBASE, klass.ARHEIGHT))
            con.closePath()
            con.addRect(CGRect(0,klass.ARHEIGHT,klass.ARBASE,15))
            con.clip()
            lin.draw(at:CGPoint(-40,-40))
            con.restoreGState()
            
        }
        
        // draw the body, to go behind the view part of our rectangle (i.e. rect minus arrow)
//        var arrow = CGRect.zero
//        var body = CGRect.zero
//        rect.__divided(slice: &arrow, remainder: &body, atDistance: klass.ARHEIGHT, from: .minYEdge)
        let (_,body) = rect.divided(atDistance: type(of:self).ARHEIGHT, from: .minYEdge)
        lin.draw(in:body)
        
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsetsMake(20,20,20,20)
    }
    
}
