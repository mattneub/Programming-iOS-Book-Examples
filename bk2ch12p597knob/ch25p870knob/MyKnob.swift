
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
            self.transform = CGAffineTransformMakeRotation(self.angle)
        }
    }
    var continuous = false
    private var initialAngle : CGFloat = 0

    func pToA (touch:UITouch) -> CGFloat {
        let loc = touch.locationInView(self)
        let c = CGPointMake(self.bounds.midX, self.bounds.midY)
        return atan2(loc.y - c.y, loc.x - c.x)
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        self.initialAngle = pToA(touch)
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        let ang = pToA(touch) - self.initialAngle
        let absoluteAngle = self.angle + ang
        switch absoluteAngle { // how to do inequalities in a Swift switch statement
        case let ang where ang < 0:
            self.angle = 0
            self.sendActionsForControlEvents(.ValueChanged)
            return false
        case let ang where ang > 5:
            self.angle = 5
            self.sendActionsForControlEvents(.ValueChanged)
            return false
        default:
            self.angle = absoluteAngle
            if self.continuous {
                self.sendActionsForControlEvents(.ValueChanged)
            }
            return true
        }
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        self.sendActionsForControlEvents(.ValueChanged)
    }
    
    override func drawRect(rect: CGRect) {
        UIImage(named:"knob.png")!.drawInRect(rect)
    }
    
}
