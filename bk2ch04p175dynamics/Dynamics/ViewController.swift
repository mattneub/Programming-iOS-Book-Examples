
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


class MyGravityBehavior : UIGravityBehavior {
    deinit {
        print("farewell from grav")
    }
}

class MyImageView : UIImageView {
    // new in iOS 9, we can describe the shape of our image view for collisions
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    override func willMove(toWindow newWindow: UIWindow?) {
        print("image view move to \(newWindow as Any)")
    }
    deinit {
        print("farewell from iv")
    }
}

extension UIDynamicAnimator {
    // work around absolutely unbelievable iOS 11 bug
    // we should be able to say let items = anim.items(in: sup.bounds) as! UIView
    // but a collision behavior has fallen into the array, so we crash if we say that
    // in fact, we can't even fetch items(in:) as a Swift array at all
    func views(in rect: CGRect) -> [UIView] {
        // return self.items(in:rect) as! [UIView]
        let nsitems = self.items(in: rect) as NSArray
        return nsitems.compactMap {$0 as? UIView}
    }
}


class ViewController : UIViewController {
    
    @IBOutlet weak var iv : UIImageView!
    var anim : UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.anim = UIDynamicAnimator(referenceView: self.view)
        self.anim.delegate = self
    }
    
    let which = 3

    @IBAction func doButton(_ sender: Any?) {
        (sender as! UIButton).isEnabled = false
        
        let grav = MyGravityBehavior()
        
        /*
        The retain cycle issue here is more complicated than I thought.
        I demonstrate some alternatives...
        */
        
        switch which {
        case 1:
            // leak! neither the image view nor the gravity behavior is released
            grav.action = {
                // let items = self.anim.items(in: self.view.bounds) as! [UIView]
                // crash because it contains, wrongly, a collision behavior object
                let items = self.anim.views(in: self.view.bounds)
                let ix = items.firstIndex(of:self.iv)
                if ix == nil {
                    self.anim.removeAllBehaviors()
                    self.iv.removeFromSuperview()
                    print("done")
                }
            }
        case 2:
            grav.action = {
                let items = self.anim.views(in:self.view.bounds)
                let ix = items.firstIndex(of:self.iv)
                if ix == nil {
                    self.anim.removeAllBehaviors()
                    self.iv.removeFromSuperview()
                    self.anim = nil // * both are released
                    print("done")
                }
            }
        case 3:
            grav.action = {
                let items = self.anim.views(in:self.view.bounds)
                let ix = items.firstIndex(of:self.iv)
                if ix == nil {
                    delay(0) { // * both are released
                        self.anim.removeAllBehaviors()
                        self.iv.removeFromSuperview()
                        print("done")
                    }
                }
            }
        case 4:
            grav.action = {
                [weak grav] in // *
                if let grav = grav {
                    let items = self.anim.views(in:self.view.bounds)
                    let ix = items.firstIndex(of:self.iv)
                    if ix == nil {
                        self.anim.removeBehavior(grav) // * grav is released, iv is not!
                        self.anim.removeAllBehaviors() // probably because of the other behaviors
                        self.iv.removeFromSuperview()
                        print("done")
                    }
                }
            }
        default: break
        }
        
        self.anim.addBehavior(grav)
        grav.addItem(self.iv)
        
        // ========
        
        let push = UIPushBehavior(items:[self.iv], mode:.instantaneous)
        push.pushDirection = CGVector(1,0)
        // push.setTargetOffsetFromCenter(UIOffsetMake(0,-200), for: self.iv)
        self.anim.addBehavior(push)

        // ========
        
        let coll = UICollisionBehavior()
        coll.collisionMode = .boundaries
        coll.collisionDelegate = self
        let b = self.view.bounds
        coll.addBoundary(withIdentifier:"floor" as NSString,
            from:CGPoint(b.minX, b.maxY), to:CGPoint(b.maxX, b.maxY))
        self.anim.addBehavior(coll)
        coll.addItem(self.iv)

        // =========
        
        let bounce = UIDynamicItemBehavior()
        bounce.elasticity = 0.8
        self.anim.addBehavior(bounce)
        bounce.addItem(self.iv)
        
        
        
    }
    
}

extension ViewController : UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print("pause")
    }
    
    func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
        print("resume")
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior,
        beganContactFor item: UIDynamicItem,
        withBoundaryIdentifier identifier: NSCopying?,
        at p: CGPoint) {
            print(p)
            // look for the dynamic item behavior
            let b = self.anim.behaviors
            if let bounce = (b.compactMap {$0 as? UIDynamicItemBehavior}).first {
                let v = bounce.angularVelocity(for:item)
                print(v)
                if v <= 6 {
                    print("adding angular velocity")
                    bounce.addAngularVelocity(6, for:item)
                }
            }
    }
    
}
