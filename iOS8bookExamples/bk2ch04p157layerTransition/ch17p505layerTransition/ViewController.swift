

import UIKit


class ViewController : UIViewController {
    
    @IBOutlet var v : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lay = CALayer()
        lay.frame = self.v.layer.bounds
        self.v.layer.addSublayer(lay)
        lay.contents = UIImage(named:"Mars")!.CGImage
        lay.contentsGravity = kCAGravityResizeAspectFill
        self.v.layer.masksToBounds = true // try making this false to see what difference it makes
        self.v.layer.borderWidth = 2
        
    }
    
    @IBAction func doButton(sender:AnyObject?) {
        let lay = self.v.layer.sublayers[0] as! CALayer
        let t = CATransition()
        t.type = kCATransitionPush
        t.subtype = kCATransitionFromBottom
        t.duration = 2
        CATransaction.setDisableActions(true)
        lay.contents = UIImage(named: "Smiley")!.CGImage
        lay.addAnimation(t, forKey: nil)

    }
    
}