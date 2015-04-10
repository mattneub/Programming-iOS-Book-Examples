

import UIKit
// and note use of bridging header, essential to import hidden methods

class HorizPanGestureRecognizer : UIPanGestureRecognizer {
    var origLoc : CGPoint!
    
    override func touchesBegan(touches: Set<NSObject>, withEvent e: UIEvent) {
        self.origLoc = (touches.first as! UITouch).locationInView(self.view!.superview)
        super.touchesBegan(touches, withEvent:e)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent e: UIEvent) {
        if self.state == .Possible {
            let loc = (touches.first as! UITouch).locationInView(self.view!.superview)
            let deltaX = fabs(loc.x - self.origLoc.x)
            let deltaY = fabs(loc.y - self.origLoc.y)
            if deltaY >= deltaX {
                self.state = .Failed
            }
        }
        super.touchesMoved(touches, withEvent:e)
    }
    
    override func translationInView(view: UIView) -> CGPoint {
        var proposedTranslation = super.translationInView(view)
        proposedTranslation.y = 0
        return proposedTranslation
    }

}

class VertPanGestureRecognizer : UIPanGestureRecognizer {
    var origLoc : CGPoint!
    
    override func touchesBegan(touches: Set<NSObject>, withEvent e: UIEvent) {
        self.origLoc = (touches.first as! UITouch).locationInView(self.view!.superview)
        super.touchesBegan(touches, withEvent:e)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent e: UIEvent) {
        if self.state == .Possible {
            let loc = (touches.first as! UITouch).locationInView(self.view!.superview)
            let deltaX = fabs(loc.x - self.origLoc.x)
            let deltaY = fabs(loc.y - self.origLoc.y)
            if deltaX >= deltaY {
                self.state = .Failed
            }
        }
        super.touchesMoved(touches, withEvent:e)
    }
    
    override func translationInView(view: UIView) -> CGPoint {
        var proposedTranslation = super.translationInView(view)
        proposedTranslation.x = 0
        return proposedTranslation
    }

}
