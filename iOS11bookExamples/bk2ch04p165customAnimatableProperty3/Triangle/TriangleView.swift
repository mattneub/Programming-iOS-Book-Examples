

import UIKit

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



class TriangleView: UIView {
    
    var v1x : CGFloat {
        set {
            let lay = self.layer as! TriangleLayer
            lay.v1x = newValue
        }
        get {
            let lay = self.layer as! TriangleLayer
            return lay.v1x
        }
    }
    var v1y : CGFloat {
        set {
            let lay = self.layer as! TriangleLayer
            lay.v1y = newValue
        }
        get {
            let lay = self.layer as! TriangleLayer
            return lay.v1y
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        let lay = self.layer as! TriangleLayer
        lay.v1x = 0
        lay.v1y = 100
    }
    override class var layerClass : AnyClass {
        return TriangleLayer.self
    }
    override func draw(_ rect: CGRect) {}
}

class TriangleLayer : CALayer {
    
    @NSManaged var v1x : CGFloat
    @NSManaged var v1y : CGFloat
    
    override func draw(in con: CGContext) {
        con.move(to:CGPoint(0,0))
        con.addLine(to:CGPoint(self.bounds.size.width, 0))
        con.addLine(to:CGPoint(self.v1x, self.v1y))
        con.setFillColor(UIColor.blue.cgColor)
        con.fillPath()
        // println(self)
        // interesting, self is actually a different presentation layer per frame
    }
        
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(v1x) || key == #keyPath(v1y) {
            return true
        }
        return super.needsDisplay(forKey:key)
    }
        
    override func action(forKey key: String) -> CAAction? {
        if self.presentation() != nil {
            if key == #keyPath(v1x) || key == #keyPath(v1y) {
                let ba = CABasicAnimation(keyPath: key)
                ba.fromValue = self.presentation()!.value(forKey:key)
                return ba
            }
        }
        return super.action(forKey: key)
    }
}
