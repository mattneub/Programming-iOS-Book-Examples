
import UIKit

class ViewController : UIViewController {
    var anim : UIDynamicAnimator!
    var att : UIAttachmentBehavior!
    
    @IBAction func panning(g: UIPanGestureRecognizer) {
        switch g.state {
        case .Began:
            self.anim = UIDynamicAnimator(referenceView:self.view)
            self.anim.delegate = self
            let loc = g.locationOfTouch(0, inView:g.view)
            let cen = CGPointMake(g.view!.bounds.midX, g.view!.bounds.midY)
            let off = UIOffsetMake(loc.x-cen.x, loc.y-cen.y)
            let anchor = g.locationOfTouch(0, inView:self.view)
            let att = UIAttachmentBehavior(item:g.view!,
                offsetFromCenter:off, attachedToAnchor:anchor)
            self.anim.addBehavior(att)
            self.att = att
        case .Changed:
            self.att.anchorPoint = g.locationOfTouch(0, inView: self.view)
        default:
            self.anim = nil
        }
    }
}

extension ViewController : UIDynamicAnimatorDelegate {
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        println("pause")
    }
    func dynamicAnimatorWillResume(animator: UIDynamicAnimator) {
        println("resume")
    }

}

// unused code
/*

- (IBAction)panning:(UIPanGestureRecognizer*)g {
if (g.state == UIGestureRecognizerStateBegan) {
self.anim = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
self.anim.delegate = self;

self.atts = [NSMutableArray new];
CGRect r = CGRectInset(g.view.frame, -20, -20);
CGRect f = g.view.frame;
CGPoint cen = g.view.center;
CGFloat damp = 0.95;
CGFloat freq = 200;

CGPoint p;
UIOffset off;
UIAttachmentBehavior* att;

p = CGPointMake(CGRectGetMinX(r), CGRectGetMinY(r));
off = UIOffsetMake(CGRectGetMinX(f)-cen.x, CGRectGetMinY(f)-cen.y);
att = [[UIAttachmentBehavior alloc] initWithItem:g.view offsetFromCenter:off attachedToAnchor:p];
att.damping = damp; att.frequency = freq;
[self.anim addBehavior:att];
[self.atts addObject: att];

p = CGPointMake(CGRectGetMaxX(r), CGRectGetMaxY(r));
off = UIOffsetMake(CGRectGetMaxX(f)-cen.x, CGRectGetMaxY(f)-cen.y);
att = [[UIAttachmentBehavior alloc] initWithItem:g.view offsetFromCenter:off attachedToAnchor:p];
att.damping = damp; att.frequency = freq;
[self.anim addBehavior:att];
[self.atts addObject: att];

p = CGPointMake(CGRectGetMaxX(r), CGRectGetMinY(r));
off = UIOffsetMake(CGRectGetMaxX(f)-cen.x, CGRectGetMinY(f)-cen.y);
att = [[UIAttachmentBehavior alloc] initWithItem:g.view offsetFromCenter:off attachedToAnchor:p];
att.damping = damp; att.frequency = freq;
[self.anim addBehavior:att];
[self.atts addObject: att];

p = CGPointMake(CGRectGetMinX(r), CGRectGetMaxY(r));
off = UIOffsetMake(CGRectGetMinX(f)-cen.x, CGRectGetMaxY(f)-cen.y);
att = [[UIAttachmentBehavior alloc] initWithItem:g.view offsetFromCenter:off attachedToAnchor:p];
att.damping = damp; att.frequency = freq;
[self.anim addBehavior:att];
[self.atts addObject: att];



}
else if (g.state == UIGestureRecognizerStateChanged) {
CGPoint delta = [g translationInView: g.view.superview];
for (UIAttachmentBehavior* att in self.atts) {
CGPoint p = att.anchorPoint;
p.x += delta.x; p.y += delta.y;
att.anchorPoint = p;
}
[g setTranslation: CGPointZero inView: g.view.superview];
}

else {
NSLog(@"%f %f %f", self.att.length, self.att.damping, self.att.frequency);
self.atts = nil;
self.anim = nil;
g.view.transform = CGAffineTransformIdentity;
}
}

*/

