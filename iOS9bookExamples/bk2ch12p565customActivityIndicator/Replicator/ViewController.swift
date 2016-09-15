

import UIKit


class ViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let lay = CAReplicatorLayer()
        lay.frame = CGRectMake(0,0,100,20)
        let bar = CALayer()
        bar.frame = CGRectMake(0,0,10,20)
        bar.backgroundColor = UIColor.redColor().CGColor
        lay.addSublayer(bar)
        lay.instanceCount = 5
        lay.instanceTransform = CATransform3DMakeTranslation(20, 0, 0)
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 1.0
        anim.toValue = 0.2
        anim.duration = 1
        anim.repeatCount = Float.infinity
        bar.addAnimation(anim, forKey: nil)
        lay.instanceDelay = anim.duration / Double(lay.instanceCount)
        self.view.layer.addSublayer(lay)
        lay.position = CGPointMake(self.view.layer.bounds.midX, self.view.layer.bounds.midY)
        
    }

}

