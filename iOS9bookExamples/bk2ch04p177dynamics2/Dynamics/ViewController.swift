

import UIKit

class MyImageView : UIImageView {
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .Ellipse
    }
    override func willMoveToWindow(newWindow: UIWindow?) {
        print("image view move to \(newWindow)")
    }
    deinit {
        print("farewell from image view")
    }
}

class ViewController : UIViewController, UIDynamicAnimatorDelegate {
    @IBOutlet weak var iv : UIImageView!
    var anim : UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.anim = UIDynamicAnimator(referenceView: self.view)
        self.anim.delegate = self
    }
    
    @IBAction func doButton(sender:AnyObject?) {
        (sender as! UIButton).enabled = false
        self.anim.addBehavior(MyDropBounceAndRollBehavior(view:self.iv))
    }
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        print("pause")
    }
    
    func dynamicAnimatorWillResume(animator: UIDynamicAnimator) {
        print("resume")
    }

}
