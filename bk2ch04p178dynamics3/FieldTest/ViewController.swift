

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
extension CGRect {
    var center : CGPoint {
        return CGPoint(x:self.midX, y:self.midY)
    }
}




class MyDelayedFieldBehavior : UIFieldBehavior {
    
    // ignore, just testing the syntax
    let b = UIFieldBehavior.field {
        (beh, pt, v, m, c, t) -> CGVector in
        if t > 0.25 {
            return CGVector(-v.dx, -v.dy)
        }
        return CGVector(0,0)
    }

    
    var delay = 0.0
    class func dragField(delay del:Double) -> Self {
        let f = self.field {
            (beh, pt, v, m, c, t) -> CGVector in
            if t > (beh as! MyDelayedFieldBehavior).delay {
                return CGVector(-v.dx, -v.dy)
            }
            return CGVector(0,0)
        }
        f.delay = del
        return f
    }
}


class ViewController: UIViewController {
    
    var anim : UIDynamicAnimator!
    
    let which = 1

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.anim = UIDynamicAnimator(referenceView: self.view)
        
        let v = UIView(frame:CGRect(0,0,50,50))
        v.backgroundColor = .black
        self.view.addSubview(v)
        
        switch which {
        case 1:
            let v2 = UIView(frame:CGRect(200,0,50,50))
            v2.backgroundColor = .red
            self.view.addSubview(v2)
            
            let a = UIAttachmentBehavior.slidingAttachment(with:v, attachedTo: v2, attachmentAnchor: CGPoint(125,25), axisOfTranslation: CGVector(0,1))
            a.attachmentRange = UIFloatRange(minimum: -200,maximum: 200)
            self.anim.addBehavior(a)
            
            delay(2) {
                print("push")
                let p = UIPushBehavior(items: [v], mode: .continuous)
                p.pushDirection = CGVector(0,0.05)
                self.anim.addBehavior(p)
            }
        case 2:
            let b = MyDelayedFieldBehavior.dragField(delay:0.95)
            b.region = UIRegion(size: self.view.bounds.size)
            b.position = self.view.bounds.center
            b.addItem(v)
            self.anim.addBehavior(b)
            
            let p = UIPushBehavior(items: [v], mode: .instantaneous)
            p.pushDirection = CGVector(0.5, 0.5)
            self.anim.addBehavior(p)
        case 3:
            let v2 = UIView(frame:CGRect(200,0,50,50))
            v2.backgroundColor = UIColor.red
            self.view.addSubview(v2)
            
            let anch = UIDynamicItemBehavior(items: [v2])
            anch.isAnchored = true
            self.anim.addBehavior(anch)
            
            let b = UIFieldBehavior.linearGravityField(direction:CGVector(0,1))
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
        self.anim.perform(Selector(("setDebugEnabled:")), with:true)
    }

}

