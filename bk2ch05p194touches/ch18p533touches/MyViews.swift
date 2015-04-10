

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class MyView0 : UIView {
    
    override func touchesMoved(touches: Set<NSObject>, withEvent e: UIEvent) {
        self.superview!.bringSubviewToFront(self)
        
        let t = touches.first as! UITouch
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent e: UIEvent) {
        self.decided = false
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent e: UIEvent) {
        self.superview!.bringSubviewToFront(self)
        
        let t = touches.first as! UITouch
        
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
    var time : NSTimeInterval!
    var single = false
    
    /*
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.time = (touches.anyObject() as UITouch).timestamp
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let diff = event.timestamp - self.time
        if (diff < 0.4) {
            println("short")
        } else {
            println("long")
        }
    }

*/
    
    // see 54cf020903 for an earlier, overblown attempt using timer dispatch source
    // (because they can be cancelled, unlike dispatch_after)
    // see also http://stackoverflow.com/questions/8113268/how-to-cancel-nsblockoperation
    // but I don't think any of that is needed here, any more than
    // any complexity was needed with cancel...requests, as it is a single main-thread cancellation
    
    override func touchesBegan(touches: Set<NSObject>, withEvent e: UIEvent) {
        let ct = (touches.first as! UITouch).tapCount
        switch ct {
        case 2:
            self.single = false
        default: break
        }
        // logging to show that location in the window gives a very different result in iOS 8 from iOS 7
        let t = touches.first as! UITouch
        println(t.locationInView(self))
        println(t.locationInView(self.window!))
        println(t.locationInView(nil))

    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent e: UIEvent) {
        let ct = (touches.first as! UITouch).tapCount
        switch ct {
        case 1:
            self.single = true
            delay(0.3) {
                if self.single { // no second tap intervened
                    println("single tap")
                }
            }
        case 2:
            println("double tap")
        default: break
        }
    }
    
    // dropped the long-press example
    /*
    - (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self->_time = [(UITouch*)touches.anyObject timestamp];
    [self performSelector:@selector(touchWasLong)
    withObject:nil afterDelay:0.4];
    }
    
    - (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSTimeInterval diff = event.timestamp - self->_time;
    if (diff < 0.4) {
    NSLog(@"short");
    [NSObject cancelPreviousPerformRequestsWithTarget:self
    selector:@selector(touchWasLong)
    object:nil];
    }
*/
}

class MyView3 : UIView {
    var decidedDirection = false
    var horiz = false
    var decidedTapOrDrag = false
    var drag = false
    var single = false
    
    override func touchesBegan(touches: Set<NSObject>, withEvent e: UIEvent) {
        // be undecided
        self.decidedTapOrDrag = false
        // prepare for a tap
        let ct = (touches.first as! UITouch).tapCount
        switch ct {
        case 2:
            self.single = false
            self.decidedTapOrDrag = true
            self.drag = false
            return
        default: break
        }
        // prepare for a drag
        self.decidedDirection = false
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent e: UIEvent) {
        if self.decidedTapOrDrag && !self.drag {return}
        
        self.superview!.bringSubviewToFront(self)
        let t = touches.first as! UITouch
        
        self.decidedTapOrDrag = true
        self.drag = true
        if !self.decidedDirection {
            self.decidedDirection = true
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
    
    override func touchesEnded(touches: Set<NSObject>, withEvent e: UIEvent) {
        if !self.decidedTapOrDrag || !self.drag {
            // end for a tap
            let ct = (touches.first as! UITouch).tapCount
            switch ct {
            case 1:
                self.single = true
                delay(0.3) {
                    if self.single {
                        println("single tap")
                    }
                }
            case 2:
                println("double tap")
            default: break
            }
        }
    }
    
}

