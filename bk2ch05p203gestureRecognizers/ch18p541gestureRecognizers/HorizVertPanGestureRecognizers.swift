

import UIKit
// and note use of bridging header, essential to import hidden methods

class HorizPanGestureRecognizer : UIPanGestureRecognizer {
    var origLoc : CGPoint!
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.origLoc = (touches.anyObject() as UITouch).locationInView(self.view.superview)
        super.touchesBegan(touches, withEvent:event)
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        if self.state == .Possible {
            let loc = (touches.anyObject() as UITouch).locationInView(self.view.superview)
            let deltaX = fabs(loc.x - self.origLoc.x)
            let deltaY = fabs(loc.y - self.origLoc.y)
            if deltaY >= deltaX {
                self.state = .Failed
            }
        }
        super.touchesMoved(touches, withEvent:event)
    }
    
    override func translationInView(view: UIView!) -> CGPoint {
        var proposedTranslation = super.translationInView(view)
        proposedTranslation.y = 0
        return proposedTranslation
    }

}

class VertPanGestureRecognizer : UIPanGestureRecognizer {
    var origLoc : CGPoint!
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.origLoc = (touches.anyObject() as UITouch).locationInView(self.view.superview)
        super.touchesBegan(touches, withEvent:event)
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        if self.state == .Possible {
            let loc = (touches.anyObject() as UITouch).locationInView(self.view.superview)
            let deltaX = fabs(loc.x - self.origLoc.x)
            let deltaY = fabs(loc.y - self.origLoc.y)
            if deltaX >= deltaY {
                self.state = .Failed
            }
        }
        super.touchesMoved(touches, withEvent:event)
    }
    
    override func translationInView(view: UIView!) -> CGPoint {
        var proposedTranslation = super.translationInView(view)
        proposedTranslation.x = 0
        return proposedTranslation
    }

}
