
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



class MyKnob: UIControl {
    var angle : CGFloat = 0 {
        didSet {
            self.angle = min(max(self.angle, 0), 5) // clamp
            self.transform = CGAffineTransform(rotationAngle: self.angle)
        }
    }
    var isContinuous = false
    private var initialAngle : CGFloat = 0

    func pToA (_ t:UITouch) -> CGFloat {
        let loc = t.location(in: self)
        let c = CGPoint(self.bounds.midX, self.bounds.midY)
        return atan2(loc.y - c.y, loc.x - c.x)
    }
    
    override func beginTracking(_ t: UITouch, with _: UIEvent?) -> Bool {
        self.initialAngle = pToA(t)
        return true
    }
    
    override func continueTracking(_ t: UITouch, with _: UIEvent?) -> Bool {
        let ang = pToA(t) - self.initialAngle
        let absoluteAngle = self.angle + ang
        switch absoluteAngle { // how to do inequalities in a Swift switch statement
        case -CGFloat.greatestFiniteMagnitude...0:
            self.angle = 0
            self.sendActions(for: .valueChanged)
            return false
        case 5...CGFloat.greatestFiniteMagnitude:
            self.angle = 5
            self.sendActions(for: .valueChanged)
            return false
        default:
            self.angle = absoluteAngle
            if self.isContinuous {
                self.sendActions(for: .valueChanged)
            }
            return true
        }
        // ignore, just checking syntax
        // self.transform = self.transform.rotated(by: ang)
    }
    
    override func endTracking(_: UITouch?, with _: UIEvent?) {
        self.sendActions(for: .valueChanged)
    }
    
    override func draw(_ rect: CGRect) {
        UIImage(named:"knob")!.draw(in: rect)
    }
    
}
