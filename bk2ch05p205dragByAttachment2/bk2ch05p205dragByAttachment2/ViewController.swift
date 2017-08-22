

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



class ViewController: UIViewController, UIDynamicAnimatorDelegate {
    
    @IBOutlet var constraints : [NSLayoutConstraint]!
    @IBOutlet var redView : UIView!
    
    var anim: UIDynamicAnimator!
    weak var att : UIAttachmentBehavior!
    weak var slide : UIAttachmentBehavior!
    var origCenter : CGPoint!
    
    @IBAction func drag(_ g:UIPanGestureRecognizer) {
        switch g.state {
        case .began:
            self.origCenter = self.redView.center
            
            NSLayoutConstraint.deactivate(self.constraints)
            self.redView.translatesAutoresizingMaskIntoConstraints = true
            
            self.anim = UIDynamicAnimator(referenceView: self.view)
            
            // allow red view to move vertically only
            let slide = UIAttachmentBehavior.slidingAttachment(with:self.redView, attachmentAnchor: CGPoint(self.view.bounds.midX, self.view.bounds.maxY), axisOfTranslation: CGVector(0,1))
            slide.attachmentRange = UIFloatRange(minimum: 0, maximum: 10000)
            self.anim.addBehavior(slide)
            self.slide = slide
            
            // initial touch point
            let pt = g.location(ofTouch:0, in:self.view)
            
            // attach center of red view to anchor at touch point
            let att = UIAttachmentBehavior(item: self.redView,
                offsetFromCenter: UIOffset(horizontal: 0, vertical: 10000),
                attachedToAnchor: pt)
            self.anim.addBehavior(att)
            self.att = att
            
        case .changed:
            let pt = g.location(ofTouch:0, in:self.view)
            // move anchor to follow touch
            if pt.y > self.redView.bounds.height/2 { // impose arbitrary limit
                self.att.anchorPoint = pt
            }
            
        case .ended, .cancelled:
            // user has let go! release red view
            self.anim.removeBehavior(self.att)
            
            // make a "cushion" at the floor
            let coll = UICollisionBehavior(items: [self.redView])
            coll.setTranslatesReferenceBoundsIntoBoundary(with:
                UIEdgeInsets(top: -1, left: -1, bottom: -1, right: -1))
            self.anim.addBehavior(coll)
            
            // spring red view back into its original place
            let snap = UISnapBehavior(item: self.redView, snapTo: self.origCenter)
            snap.damping = 0.3
            self.anim.addBehavior(snap)
            
            // and when we're all done...
            self.anim.delegate = self
            UIApplication.shared.beginIgnoringInteractionEvents()
            
        default:break
        }
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        // ...clean everything up, restore original layout
        UIApplication.shared.endIgnoringInteractionEvents()
        self.anim = nil
        self.redView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(self.constraints)
        print("done")
    }
}

