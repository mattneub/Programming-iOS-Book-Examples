

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class MyDelayedFieldBehavior : UIFieldBehavior {
    var delay = 0.0
    class func dragFieldWithDelay(del:Double) -> Self {
        let f = self.fieldWithEvaluationBlock {
            (beh, pt, v, m, c, t) -> CGVector in
            if t > (beh as! MyDelayedFieldBehavior).delay {
                return CGVectorMake(-v.dx, -v.dy)
            }
            return CGVectorMake(0,0)
        }
        f.delay = del
        return f
    }
}


class ViewController: UIViewController {
    
    var anim : UIDynamicAnimator!
    
    let which = 3

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.anim = UIDynamicAnimator(referenceView: self.view)
        
        let v = UIView(frame:CGRectMake(0,0,50,50))
        v.backgroundColor = UIColor.blackColor()
        self.view.addSubview(v)
        
        switch which {
        case 1:
            let v2 = UIView(frame:CGRectMake(200,0,50,50))
            v2.backgroundColor = UIColor.redColor()
            self.view.addSubview(v2)
            
            let a = UIAttachmentBehavior.slidingAttachmentWithItem(v, attachedToItem: v2, attachmentAnchor: CGPointMake(125,25), axisOfTranslation: CGVectorMake(0,1))
            a.attachmentRange = UIFloatRangeMake(-200,200)
            self.anim.addBehavior(a)
            
            delay(2) {
                print("push")
                let p = UIPushBehavior(items: [v], mode: .Continuous)
                p.pushDirection = CGVectorMake(0,0.05)
                self.anim.addBehavior(p)
            }
        case 2:
            let b = MyDelayedFieldBehavior.dragFieldWithDelay(0.95)
            b.region = UIRegion(size: self.view.bounds.size)
            b.position = CGPointMake(self.view.bounds.midX, self.view.bounds.midY)
            b.addItem(v)
            self.anim.addBehavior(b)
            
            let p = UIPushBehavior(items: [v], mode: .Instantaneous)
            p.pushDirection = CGVectorMake(0.5, 0.5)
            self.anim.addBehavior(p)
        case 3:
            let v2 = UIView(frame:CGRectMake(200,0,50,50))
            v2.backgroundColor = UIColor.redColor()
            self.view.addSubview(v2)
            
            let anch = UIDynamicItemBehavior(items: [v2])
            anch.anchored = true
            self.anim.addBehavior(anch)
            
            let b = UIFieldBehavior.linearGravityFieldWithVector(CGVectorMake(0,1))
            b.addItem(v)
            b.strength = 2
            self.anim.addBehavior(b)
            
            delay(2) {
                let a = UIAttachmentBehavior(item: v, attachedToItem: v2)
                print(a.damping)
                print(a.frequency)
                a.frequency = 4
                self.anim.addBehavior(a)
            }


        default:break
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("here")
    }

}

