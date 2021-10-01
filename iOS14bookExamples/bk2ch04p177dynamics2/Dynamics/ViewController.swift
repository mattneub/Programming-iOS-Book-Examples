

import UIKit

class MyImageView : UIImageView {
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    override func willMove(toWindow newWindow: UIWindow?) {
        print("image view move to \(newWindow as Any)")
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
    
    @IBAction func doButton(_ sender: Any?) {
        (sender as! UIButton).isEnabled = false
        self.anim.addBehavior(MyDropBounceAndRollBehavior(view:self.iv))
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print("pause")
    }
    
    func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
        print("resume")
    }

}
