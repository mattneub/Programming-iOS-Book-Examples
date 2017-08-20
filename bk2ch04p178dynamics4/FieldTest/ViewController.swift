

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

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


// just a workshop for playing with fields; feel free to change anything and experiment

class ViewController: UIViewController {
    
    var anim : UIDynamicAnimator!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.anim = UIDynamicAnimator(referenceView: self.view)
        
        let v = UIView(frame:CGRect(100,0,50,50))
        v.backgroundColor = UIColor.black
        self.view.addSubview(v)
        
        delay(1) {
        
            let p = UIPushBehavior(items: [v], mode: .instantaneous)
            p.pushDirection = CGVector(0.5, 1)
            self.anim.addBehavior(p)
            
            let b = UIDynamicItemBehavior(items:[v])
            b.charge = 0.2
            self.anim.addBehavior(b)

            // let f = UIFieldBehavior.electricField()
            let f = UIFieldBehavior.magneticField()
            let r = self.anim.referenceView!.bounds
            f.position = CGPoint(r.midX, r.midY)
            f.falloff = 1
            f.strength = 1
            f.addItem(v)
            self.anim.addBehavior(f)
        }
        
        delay(0.3) {
            // self.anim.perform(Selector(("setDebugEnabled:")), with:true)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("here")
    }

}

