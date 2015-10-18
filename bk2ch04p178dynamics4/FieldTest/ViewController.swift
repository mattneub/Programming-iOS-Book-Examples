

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

// just a workshop for playing with fields; feel free to change anything and experiment

class ViewController: UIViewController {
    
    var anim : UIDynamicAnimator!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.anim = UIDynamicAnimator(referenceView: self.view)
        
        let v = UIView(frame:CGRectMake(100,0,50,50))
        v.backgroundColor = UIColor.blackColor()
        self.view.addSubview(v)
        
        delay(1) {
        
            let p = UIPushBehavior(items: [v], mode: .Instantaneous)
            p.pushDirection = CGVectorMake(0.5, 1)
            self.anim.addBehavior(p)
            
            let b = UIDynamicItemBehavior(items:[v])
            b.charge = 10
            self.anim.addBehavior(b)

            // let f = UIFieldBehavior.electricField()
            let f = UIFieldBehavior.magneticField()
            let r = self.anim.referenceView!.bounds
            f.position = CGPointMake(r.midX, r.midY)
            f.strength = 1
            f.addItem(v)
            self.anim.addBehavior(f)
            
        }
        
        // delay(0.3) { self.anim.performSelector("setDebugEnabled:", withObject:true) }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("here")
    }

}

