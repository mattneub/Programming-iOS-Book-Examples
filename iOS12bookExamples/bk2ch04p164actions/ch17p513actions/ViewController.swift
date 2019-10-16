import UIKit

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


class MyAction : NSObject, CAAction {
    func run(forKey event: String, object anObject: Any,
        arguments dict: [AnyHashable : Any]?) {
            let anim = CABasicAnimation(keyPath: event)
            anim.duration = 5
            let lay = anObject as! CALayer
            let newP = lay.value(forKey:event)
            let oldP = lay.presentation()!.value(forKey:event)
            print("from \(oldP as Any) to \(newP as Any)")
            lay.add(anim, forKey:nil)
    }
}

class MyWagglePositionAction : NSObject, CAAction {
    func run(forKey event: String, object anObject: Any,
        arguments dict: [AnyHashable : Any]?) {
            let lay = anObject as! CALayer
            let newP = lay.value(forKey:event) as! CGPoint
            let oldP = lay.presentation()!.value(forKey:event) as! CGPoint

            let d = sqrt(pow(oldP.x - newP.x, 2) + pow(oldP.y - newP.y, 2))
            let r = Double(d/3.0)
            let theta = Double(atan2(newP.y - oldP.y, newP.x - oldP.x))
            let wag = 10 * .pi/180.0
            let p1 = CGPoint(
                oldP.x + CGFloat(r*cos(theta+wag)),
                oldP.y + CGFloat(r*sin(theta+wag)))
            let p2 = CGPoint(
                oldP.x + CGFloat(r*2*cos(theta-wag)),
                oldP.y + CGFloat(r*2*sin(theta-wag)))
            let anim = CAKeyframeAnimation(keyPath: event)
            anim.values = [oldP,p1,p2,newP]
            anim.calculationMode = .cubic
            
            lay.add(anim, forKey:nil)
    }
}

class ViewController : UIViewController {
    var layer : CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = MyLayer()
        layer.frame = CGRect(50,50,40,40)
        CATransaction.setDisableActions(true) // prevent MyLayer automatic contents animation on next line
        layer.contents = UIImage(named:"Mars")!.cgImage
        layer.contentsGravity = .resizeAspectFill
        self.view.layer.addSublayer(layer)
        self.layer = layer
    }
    
    let which = 10 // 1...10
    
    @IBAction func doButton(_ sender: Any?) {
        let layer = self.layer!
        
        switch which {
        case 1:
            layer.position = CGPoint(100,100) // proving that it normally works
            
        case 2:
            // turn off position animation for this layer
            layer.setValue(true, forKey:"suppressPositionAnimation")
            layer.position = CGPoint(100,100) // look Ma, no animation!
            
        case 3:
            // put a "position" entry into the layer's actions dictionary
            let ba = CABasicAnimation()
            ba.duration = 5
            layer.actions = ["position": ba]
            layer.delegate = nil // use actions dictionary, not delegate
            
            // use implicit property animation
            let newP = CGPoint(100,100)
            CATransaction.setAnimationDuration(1.5)
            layer.position = newP
            // the animation "ba" will be used, with its 5-second duration
            
        case 4:
            // put a much more powerful "position" entry into the layer's actions dictionary
            layer.actions = ["position": MyAction()]
            layer.delegate = nil

            // use implicit property animation
            let newP = CGPoint(100,100)
            CATransaction.setAnimationDuration(1.5)
            layer.position = newP
            // the animation still has a 5-second duration

        case 5:
            
            layer.delegate = nil
            layer.actions = ["position": MyWagglePositionAction()]
            
            CATransaction.setAnimationDuration(0.4)
            layer.position = CGPoint(200,200) // waggle
            
        case 6:
            // same as preceding but we use the delegate
            layer.delegate = self
            CATransaction.setAnimationDuration(0.4)
            layer.position = CGPoint(200,200) // waggle

            
        case 7:
            // layer automatically turns this into a push-from-left transition
            layer.contents = UIImage(named:"Smiley")!.cgImage

        case 8:
            let layer = CALayer()
            layer.frame = CGRect(200,50,40,40)
            layer.contentsGravity = .resizeAspectFill
            layer.contents = UIImage(named:"Smiley")!.cgImage
            layer.delegate = self
            self.view.layer.addSublayer(layer)
            // the delegate (me) will "pop" the layer as it appears

        case 9:
            layer.delegate = self
            
            CATransaction.setCompletionBlock({
                layer.removeFromSuperlayer()
                })
            CATransaction.setValue("", forKey:"bye")
            layer.opacity = 0
            // the delegate (me) will "shrink" the layer as it disappears

        case 10:
            // intended to supersede the preceding; I think this is a much neater way
            layer.delegate = self
            layer.setValue("", forKey:"farewell")
            // the delegate will "shrink" the layer and remove it

            
        default: break
        }
    }
}

class MyLayer : CALayer {
    
    // layer whose response to contents setting is automatic push from left
    
    override class func defaultAction(forKey key: String) -> CAAction? {
        if key == #keyPath(contents) {
            let tr = CATransition()
            tr.type = .push
            tr.subtype = .fromLeft
            return tr
        }
        return super.defaultAction(forKey:key)
    }
    
    // layer whose implicit position animation can be turned off
    
    override func action(forKey key: String) -> CAAction? {
        if key == #keyPath(position) {
            if self.value(forKey:"suppressPositionAnimation") != nil {
                return nil
            }
        }
        return super.action(forKey:key)
    }
    
    
    override func removeFromSuperlayer() {
        print("I'm being removed from my superlayer")
        super.removeFromSuperlayer()
    }
    
}

extension ViewController : CALayerDelegate, CAAnimationDelegate {
    
    // on implicit "position" animation, do a little waggle
    func action(for layer: CALayer, forKey key: String) -> CAAction? {
        if key == #keyPath(CALayer.position) {
            return MyWagglePositionAction()
        }
        
        // on layer addition (addSublayer this layer), "pop" into view
        if key == kCAOnOrderIn {
            let anim1 = CABasicAnimation(keyPath:#keyPath(CALayer.opacity))
            anim1.fromValue = 0.0
            anim1.toValue = layer.opacity
            let anim2 = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim2.toValue = CATransform3DScale(layer.transform, 1.2, 1.2, 1.0)
            anim2.autoreverses = true
            anim2.duration = 0.1
            let group = CAAnimationGroup()
            group.animations = [anim1, anim2]
            group.duration = 0.2
            return group
        }
        
        // on opacity change with "bye" key, "pop" out of sight
        if key == #keyPath(CALayer.opacity) {
            if CATransaction.value(forKey:"bye") != nil {
                let anim1 = CABasicAnimation(keyPath:#keyPath(CALayer.opacity))
                anim1.fromValue = layer.opacity
                anim1.toValue = 0.0
                let anim2 = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
                anim2.toValue = CATransform3DScale(layer.transform, 0.1, 0.1, 1.0)
                let group = CAAnimationGroup()
                group.animations = [anim1, anim2]
                group.duration = 0.2
                return group
            }
        }
        
        // on "farewell" key setting, "pop" out of sight and remove from superlayer
        // supersedes previous
        if key == "farewell" {
            let anim1 = CABasicAnimation(keyPath:#keyPath(CALayer.opacity))
            anim1.fromValue = layer.opacity
            anim1.toValue = 0.0
            let anim2 = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim2.toValue = CATransform3DScale(layer.transform, 0.1, 0.1, 1.0)
            let group = CAAnimationGroup()
            group.animations = [anim1, anim2]
            group.duration = 0.2
            group.delegate = self // this will cause animationDidStop to be called
            group.setValue(layer, forKey:"remove") // both identifier and removal target
            layer.opacity = 0
            return group
        }

        return nil
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let layer = anim.value(forKey:"remove") as? CALayer {
            layer.removeFromSuperlayer()
        }
    }
    
}
