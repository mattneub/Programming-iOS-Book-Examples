

import UIKit

func delay(_ delay:Double, closure:()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.after(when: when, execute: closure)
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


class MyDelayedFieldBehavior : UIFieldBehavior {
    var delay = 0.0
    class func dragField(delay del:Double) -> Self {
        let f = self.field {
            (beh, pt, v, m, c, t) -> CGVector in
            if t > (beh as! MyDelayedFieldBehavior).delay {
                return CGVector(dx:-v.dx, dy:-v.dy)
            }
            return CGVector(dx:0,dy:0)
        }
        f.delay = del
        return f
    }
}


class ViewController: UIViewController {
    
    var anim : UIDynamicAnimator!
    
    let which = 3

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.anim = UIDynamicAnimator(referenceView: self.view)
        
        let v = UIView(frame:CGRect(0,0,50,50))
        v.backgroundColor = UIColor.black()
        self.view.addSubview(v)
        
        switch which {
        case 1:
            let v2 = UIView(frame:CGRect(200,0,50,50))
            v2.backgroundColor = UIColor.red()
            self.view.addSubview(v2)
            
            let a = UIAttachmentBehavior.slidingAttachment(with:v, attachedTo: v2, attachmentAnchor: CGPoint(125,25), axisOfTranslation: CGVector(dx:0,dy:1))
            a.attachmentRange = UIFloatRangeMake(-200,200)
            self.anim.addBehavior(a)
            
            delay(2) {
                print("push")
                let p = UIPushBehavior(items: [v], mode: .continuous)
                p.pushDirection = CGVector(dx:0,dy:0.05)
                self.anim.addBehavior(p)
            }
        case 2:
            let b = MyDelayedFieldBehavior.dragField(delay:0.95)
            b.region = UIRegion(size: self.view.bounds.size)
            b.position = CGPoint(self.view.bounds.midX, self.view.bounds.midY)
            b.addItem(v)
            self.anim.addBehavior(b)
            
            let p = UIPushBehavior(items: [v], mode: .instantaneous)
            p.pushDirection = CGVector(dx:0.5, dy:0.5)
            self.anim.addBehavior(p)
        case 3:
            let v2 = UIView(frame:CGRect(200,0,50,50))
            v2.backgroundColor = UIColor.red()
            self.view.addSubview(v2)
            
            let anch = UIDynamicItemBehavior(items: [v2])
            anch.isAnchored = true
            self.anim.addBehavior(anch)
            
            let b = UIFieldBehavior.linearGravityField(direction:CGVector(dx:0,dy:1))
            b.addItem(v)
            b.strength = 2
            self.anim.addBehavior(b)
            
            delay(2) {
                let a = UIAttachmentBehavior(item: v, attachedTo: v2)
                print(a.damping)
                print(a.frequency)
                a.frequency = 4
                self.anim.addBehavior(a)
            }


        default:break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("here")
    }

}

