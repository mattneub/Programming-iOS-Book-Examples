import UIKit

class MyAction : NSObject, CAAction {
    func runActionForKey(event: String, object anObject: AnyObject,
        arguments dict: [NSObject : AnyObject]?) {
            let anim = CABasicAnimation(keyPath: event)
            anim.duration = 5
            let lay = anObject as! CALayer
            let newP = lay.valueForKey(event)
            let oldP = (lay.presentationLayer() as! CALayer).valueForKey(event)
            print("from \(oldP) to \(newP)")
            lay.addAnimation(anim, forKey:nil)
    }
}

class MyWagglePositionAction : NSObject, CAAction {
    func runActionForKey(event: String, object anObject: AnyObject,
        arguments dict: [NSObject : AnyObject]?) {
            let lay = anObject as! CALayer
            let newP = (lay.valueForKey(event) as! NSValue).CGPointValue()
            let oldP = ((lay.presentationLayer() as! CALayer).valueForKey(event) as! NSValue).CGPointValue()

            let d = sqrt(pow(oldP.x - newP.x, 2) + pow(oldP.y - newP.y, 2))
            let r = Double(d/3.0)
            let theta = Double(atan2(newP.y - oldP.y, newP.x - oldP.x))
            let wag = 10*M_PI/180.0
            let p1 = CGPointMake(
                oldP.x + CGFloat(r*cos(theta+wag)),
                oldP.y + CGFloat(r*sin(theta+wag)))
            let p2 = CGPointMake(
                oldP.x + CGFloat(r*2*cos(theta-wag)),
                oldP.y + CGFloat(r*2*sin(theta-wag)))
            let anim = CAKeyframeAnimation(keyPath: event)
            anim.values = [oldP,p1,p2,newP].map{NSValue(CGPoint:$0)}
            anim.calculationMode = kCAAnimationCubic
            
            lay.addAnimation(anim, forKey:nil)
    }
}

class ViewController : UIViewController {
    var layer : CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = MyLayer()
        layer.frame = CGRectMake(50,50,40,40)
        CATransaction.setDisableActions(true) // prevent MyLayer automatic contents animation on next line
        layer.contents = UIImage(named:"Mars")!.CGImage
        layer.contentsGravity = kCAGravityResizeAspectFill
        self.view.layer.addSublayer(layer)
        self.layer = layer
    }
    
    let which = 10
    
    @IBAction func doButton(sender:AnyObject?) {
        let layer = self.layer
        
        switch which {
        case 1:
            layer.position = CGPointMake(100,100) // proving that it normally works
            
        case 2:
            // turn off position animation for this layer
            layer.setValue(true, forKey:"suppressPositionAnimation")
            layer.position = CGPointMake(100,100) // look Ma, no animation!
            
        case 3:
            // put a "position" entry into the layer's actions dictionary
            let ba = CABasicAnimation()
            ba.duration = 5
            layer.actions = ["position": ba]
            layer.delegate = nil // use actions dictionary, not delegate
            
            // use implicit property animation
            let newP = CGPointMake(100,100)
            CATransaction.setAnimationDuration(1.5)
            layer.position = newP
            // the animation "ba" will be used, with its 5-second duration
            
        case 4:
            // put a much more powerful "position" entry into the layer's actions dictionary
            layer.actions = ["position": MyAction()]
            layer.delegate = nil

            // use implicit property animation
            let newP = CGPointMake(100,100)
            CATransaction.setAnimationDuration(1.5)
            layer.position = newP
            // the animation still has a 5-second duration

        case 5:
            
            layer.delegate = nil
            layer.actions = ["position": MyWagglePositionAction()]
            
            CATransaction.setAnimationDuration(0.4)
            layer.position = CGPointMake(200,200) // waggle
            
        case 6:
            // same as preceding but we use the delegate
            layer.delegate = self
            CATransaction.setAnimationDuration(0.4)
            layer.position = CGPointMake(200,200) // waggle

            
        case 7:
            // layer automatically turns this into a push-from-left transition
            layer.contents = UIImage(named:"Smiley")!.CGImage

        case 8:
            let layer = CALayer()
            layer.frame = CGRectMake(200,50,40,40)
            layer.contentsGravity = kCAGravityResizeAspectFill
            layer.contents = UIImage(named:"Smiley")!.CGImage
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
    
    override class func defaultActionForKey(key: String) -> CAAction? {
        if key == "contents" {
            let tr = CATransition()
            tr.type = kCATransitionPush
            tr.subtype = kCATransitionFromLeft
            return tr
        }
        return super.defaultActionForKey(key)
    }
    
    // layer whose implicit position animation can be turned off
    
    override func actionForKey(key: String) -> CAAction? {
        if key == "position" {
            if self.valueForKey("suppressPositionAnimation") != nil {
                return nil
            }
        }
        return super.actionForKey(key)
    }
    
    
    override func removeFromSuperlayer() {
        print("I'm being removed from my superlayer")
        super.removeFromSuperlayer()
    }
    
}

extension ViewController {
    
    // on implicit "position" animation, do a little waggle
    override func actionForLayer(layer: CALayer, forKey key: String) -> CAAction? {
        if key == "position" {
            return MyWagglePositionAction()
        }
        
        // on layer addition (addSublayer this layer), "pop" into view
        if key == kCAOnOrderIn {
            let anim1 = CABasicAnimation(keyPath:"opacity")
            anim1.fromValue = 0.0
            anim1.toValue = layer.opacity
            let anim2 = CABasicAnimation(keyPath:"transform")
            anim2.toValue = NSValue(CATransform3D:
                CATransform3DScale(layer.transform, 1.2, 1.2, 1.0))
            anim2.autoreverses = true
            anim2.duration = 0.1
            let group = CAAnimationGroup()
            group.animations = [anim1, anim2]
            group.duration = 0.2
            return group
        }
        
        // on opacity change with "bye" key, "pop" out of sight
        if key == "opacity" {
            if CATransaction.valueForKey("bye") != nil {
                let anim1 = CABasicAnimation(keyPath:"opacity")
                anim1.fromValue = layer.opacity
                anim1.toValue = 0.0
                let anim2 = CABasicAnimation(keyPath:"transform")
                anim2.toValue = NSValue(CATransform3D:
                    CATransform3DScale(layer.transform, 0.1, 0.1, 1.0))
                let group = CAAnimationGroup()
                group.animations = [anim1, anim2]
                group.duration = 0.2
                return group
            }
        }
        
        // on "farewell" key setting, "pop" out of sight and remove from superlayer
        // supersedes previous
        if key == "farewell" {
            let anim1 = CABasicAnimation(keyPath:"opacity")
            anim1.fromValue = layer.opacity
            anim1.toValue = 0.0
            let anim2 = CABasicAnimation(keyPath:"transform")
            anim2.toValue = NSValue(CATransform3D:
                CATransform3DScale(layer.transform, 0.1, 0.1, 1.0))
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
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let layer = anim.valueForKey("remove") as? CALayer {
            layer.removeFromSuperlayer()
        }
    }
    
}