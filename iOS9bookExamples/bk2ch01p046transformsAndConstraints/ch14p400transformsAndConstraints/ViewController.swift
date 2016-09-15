

import UIKit

/*
Well, here's something I didn't expect to see: they've fixed the view transform bug!
The first view, which is constrained by its frame origin, transforms correctly in iOS 8!
Try it in iOS 7 and you'll see what the problem used to be ever since iOS 5
(the problem which the other views are demonstrating various ways to solve).

Logging reveals that the fix was exactly as I have been saying all these years:
applying the view transform no longer triggers layout in iOS 8
(neither updateConstraints on the view nor layoutSubviews on its superview is called).
Moreover, it appears that constraints are now used to calculate and set
a view's center and bounds, not its frame, as they should have been all along.
*/

class ViewController : UIViewController {
    @IBOutlet var noConstraintsView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noConstraintsView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction func doButton(g:UIGestureRecognizer) {
        let p = g.locationInView(g.view)
        if let v = g.view!.hitTest(p, withEvent: nil) {
            if v == g.view { return }
            if v is MyView { return }
            dispatch_async(dispatch_get_main_queue()) {
                self.grow(v)
            }
        }
    }
    
    func grow(v:UIView) {
        print("grow \(v)")
        v.transform = CGAffineTransformScale(v.transform, 1.2, 1.2)
        
    }
    
    @IBAction func growLayer(g:UIGestureRecognizer) {
        print("growLayer")
        let v = g.view!
        v.layer.transform = CATransform3DScale(v.layer.transform, 1.2, 1.2, 1)
    }
    
    
    
}
