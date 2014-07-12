

import UIKit

class MyView0 : UIView {
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        self.superview.bringSubviewToFront(self)
        
        let t = touches.anyObject() as UITouch
        let loc = t.locationInView(self.superview)
        let oldP = t.previousLocationInView(self.superview)
        let deltaX = loc.x - oldP.x
        let deltaY = loc.y - oldP.y
        var c = self.center
        c.x += deltaX
        c.y += deltaY
        self.center = c
    }
    
}

class MyView1 : UIView {
    var decided = false
    var horiz = false
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.decided = false
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        self.superview.bringSubviewToFront(self)
        
        let t = touches.anyObject() as UITouch
        
        if !self.decided {
            self.decided = true
            let then = t.previousLocationInView(self)
            let now = t.locationInView(self)
            let deltaX = fabs(then.x - now.x)
            let deltaY = fabs(then.y - now.y)
            self.horiz = deltaX >= deltaY
        }
        
        let loc = t.locationInView(self.superview)
        let oldP = t.previousLocationInView(self.superview)
        let deltaX = loc.x - oldP.x
        let deltaY = loc.y - oldP.y
        var c = self.center
        if self.horiz {
            c.x += deltaX
        } else {
            c.y += deltaY
        }
        self.center = c
    }
}

class MyView2 : UIView {
    var time : NSTimeInterval?
    var q : dispatch_queue_t!
    var timer : dispatch_source_t!
    var firsttime = false
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        let ct = (touches.anyObject() as UITouch).tapCount
        switch ct {
        case 2:
            if let timer = self.timer {
                dispatch_source_cancel(timer)
                self.timer = nil
            }
        default: break
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        let ct = (touches.anyObject() as UITouch).tapCount
        switch ct {
        case 1:
            if !self.q {
                self.q = dispatch_queue_create("timer",nil)
            }
            self.timer = dispatch_source_create(
                DISPATCH_SOURCE_TYPE_TIMER,
                0, 0, self.q)
            dispatch_source_set_timer(self.timer,
                dispatch_walltime(nil, 0),
                UInt64(0.3 * Double(NSEC_PER_SEC)), UInt64(0.05 * Double(NSEC_PER_SEC)))
            dispatch_source_set_event_handler(self.timer, {
                if self.firsttime {
                    self.firsttime = false
                } else {
                    println("single tap")
                    dispatch_source_cancel(self.timer)
                    self.timer = nil
                }
                })
            self.firsttime = true
            dispatch_resume(self.timer)
        case 2:
            println("double tap")
        default: break
        }
    }
}

