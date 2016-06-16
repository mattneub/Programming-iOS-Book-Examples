
import UIKit

class MyKnob: UIControl {
    var angle : CGFloat = 0 {
        didSet {
            if self.angle < 0 {
                self.angle = 0
            }
            if self.angle > 5 {
                self.angle = 5
            }
            self.transform = CGAffineTransform(rotationAngle: self.angle)
        }
    }
    var continuous = false
    private var initialAngle : CGFloat = 0

    func pToA (_ touch:UITouch) -> CGFloat {
        let loc = touch.location(in: self)
        let c = CGPoint(x:self.bounds.midX, y:self.bounds.midY)
        return atan2(loc.y - c.y, loc.x - c.x)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.initialAngle = pToA(touch)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let ang = pToA(touch) - self.initialAngle
        let absoluteAngle = self.angle + ang
        switch absoluteAngle { // how to do inequalities in a Swift switch statement
        case -CGFloat.infinity...0:
            self.angle = 0
            self.sendActions(for: .valueChanged)
            return false
        case 5...CGFloat.infinity:
            self.angle = 5
            self.sendActions(for: .valueChanged)
            return false
        default:
            self.angle = absoluteAngle
            if self.continuous {
                self.sendActions(for: .valueChanged)
            }
            return true
        }
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        self.sendActions(for: .valueChanged)
    }
    
    override func draw(_ rect: CGRect) {
        UIImage(named:"knob.png")!.draw(in: rect)
    }
    
}
