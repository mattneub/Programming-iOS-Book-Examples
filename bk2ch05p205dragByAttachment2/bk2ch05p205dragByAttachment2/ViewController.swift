

import UIKit

class ViewController: UIViewController, UIDynamicAnimatorDelegate {
    
    @IBOutlet var constraints : [NSLayoutConstraint]!
    @IBOutlet var redView : UIView!
    
    var anim: UIDynamicAnimator!
    weak var att : UIAttachmentBehavior!
    weak var slide : UIAttachmentBehavior!
    var origCenter : CGPoint!
    
    @IBAction func drag(g:UIPanGestureRecognizer) {
        switch g.state {
        case .Began:
            self.origCenter = self.redView.center
            
            NSLayoutConstraint.deactivateConstraints(self.constraints)
            self.redView.translatesAutoresizingMaskIntoConstraints = true
            
            self.anim = UIDynamicAnimator(referenceView: self.view)
            
            // allow red view to move vertically only
            let slide = UIAttachmentBehavior.slidingAttachmentWithItem(self.redView, attachmentAnchor: CGPointMake(self.view.bounds.midX, self.view.bounds.maxY), axisOfTranslation: CGVectorMake(0,1))
            slide.attachmentRange = UIFloatRange(minimum: 0, maximum: 10000)
            self.anim.addBehavior(slide)
            self.slide = slide
            
            // initial touch point
            let pt = g.locationOfTouch(0, inView:self.view)
            
            // attach center of red view to anchor at touch point
            let att = UIAttachmentBehavior(item: self.redView,
                offsetFromCenter: UIOffsetMake(0,10000),
                attachedToAnchor: pt)
            self.anim.addBehavior(att)
            self.att = att
            
        case .Changed:
            let pt = g.locationOfTouch(0, inView:self.view)
            // move anchor to follow touch
            if pt.y > self.redView.bounds.height/2 { // impose arbitrary limit
                self.att.anchorPoint = pt
            }
            
        case .Ended:
            // user has let go! release red view
            self.anim.removeBehavior(self.att)
            
            // make a "cushion" at the floor
            let coll = UICollisionBehavior(items: [self.redView])
            coll.setTranslatesReferenceBoundsIntoBoundaryWithInsets(
                UIEdgeInsetsMake(-1,-1,-1,-1))
            self.anim.addBehavior(coll)
            
            // spring red view back into its original place
            let snap = UISnapBehavior(item: self.redView, snapToPoint: self.origCenter)
            snap.damping = 0.3
            self.anim.addBehavior(snap)
            
            // and when we're all done...
            self.anim.delegate = self
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
        default:break
        }
    }
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        // ...clean everything up, restore original layout
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        self.anim = nil
        self.redView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints(self.constraints)
        print("done")
    }
}

