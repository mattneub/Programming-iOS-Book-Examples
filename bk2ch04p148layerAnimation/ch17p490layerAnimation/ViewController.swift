

import UIKit


class ViewController : UIViewController {
    @IBOutlet var compassView : CompassView!
    
    let which = 9

    @IBAction func doButton(sender:AnyObject?) {
        let c = self.compassView.layer as! CompassLayer
        let arrow = c.arrow!
        
        switch which {
        case 1:
            arrow.transform = CATransform3DRotate(
                arrow.transform, CGFloat(M_PI)/4.0, 0, 0, 1)
            
        case 2:
            CATransaction.setAnimationDuration(0.8)
            arrow.transform = CATransform3DRotate(
                arrow.transform, CGFloat(M_PI)/4.0, 0, 0, 1)
            
        case 3:
            let clunk = CAMediaTimingFunction(controlPoints: 0.9, 0.1, 0.7, 0.9)
            CATransaction.setAnimationTimingFunction(clunk)
            arrow.transform = CATransform3DRotate(arrow.transform, CGFloat(M_PI)/4.0, 0, 0, 1)

        case 4:
            // proving that the completion block works
            CATransaction.setCompletionBlock({
                print("done")
                })
            
            // capture the start and end values
            let startValue = arrow.transform
            let endValue = CATransform3DRotate(
                startValue, CGFloat(M_PI)/4.0, 0, 0, 1)
            // change the layer, without implicit animation
            CATransaction.setDisableActions(true)
            arrow.transform = endValue
            // construct the explicit animation
            let anim = CABasicAnimation(keyPath:"transform")
            anim.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim.timingFunction = clunk
            anim.fromValue = NSValue(CATransform3D:startValue)
            anim.toValue = NSValue(CATransform3D:endValue)
            // ask for the explicit animation
            arrow.addAnimation(anim, forKey:nil)
            
        case 5:
            CATransaction.setDisableActions(true)
            arrow.transform = CATransform3DRotate(
                arrow.transform, CGFloat(M_PI)/4.0, 0, 0, 1)
            let anim = CABasicAnimation(keyPath:"transform")
            anim.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim.timingFunction = clunk
            arrow.addAnimation(anim, forKey:nil)
            
        case 6:
            // capture the start and end values
            let nowValue = arrow.transform
            let startValue = CATransform3DRotate(
                nowValue, CGFloat(M_PI)/40.0, 0, 0, 1)
            let endValue = CATransform3DRotate(
                nowValue, CGFloat(-M_PI)/40.0, 0, 0, 1)
            // construct the explicit animation
            let anim = CABasicAnimation(keyPath:"transform")
            anim.duration = 0.05
            anim.timingFunction = CAMediaTimingFunction(
                name:kCAMediaTimingFunctionLinear)
            anim.repeatCount = 3
            anim.autoreverses = true
            anim.fromValue = NSValue(CATransform3D:startValue)
            anim.toValue = NSValue(CATransform3D:endValue)
            // ask for the explicit animation
            arrow.addAnimation(anim, forKey:nil)
            
        case 7:
            let anim = CABasicAnimation(keyPath:"transform")
            anim.duration = 0.05
            anim.timingFunction = CAMediaTimingFunction(
                name:kCAMediaTimingFunctionLinear)
            anim.repeatCount = 3
            anim.autoreverses = true
            anim.additive = true
            anim.valueFunction = CAValueFunction(
                name:kCAValueFunctionRotateZ)
            anim.fromValue = M_PI/40
            anim.toValue = -M_PI/40
            arrow.addAnimation(anim, forKey:nil)
            
        case 8:
            let rot = CGFloat(M_PI)/4.0
            CATransaction.setDisableActions(true)
            arrow.transform = CATransform3DRotate(arrow.transform, rot, 0, 0, 1)
            // construct animation additively
            let anim = CABasicAnimation(keyPath:"transform")
            anim.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim.timingFunction = clunk
            anim.fromValue = -rot
            anim.toValue = 0
            anim.additive = true
            anim.valueFunction = CAValueFunction(name:kCAValueFunctionRotateZ)
            arrow.addAnimation(anim, forKey:nil)

        case 9:
            var values = [0.0]
            // comma is legal in the for block!
            for (var i = 20, direction = 1.0; i < 60; i += 5, direction *= -1) { // alternate directions
                values.append( direction * M_PI / Double(i) )
            }
            values.append(0.0)
            print(values)
            let anim = CAKeyframeAnimation(keyPath:"transform")
            anim.values = values
            anim.additive = true
            anim.valueFunction = CAValueFunction(name: kCAValueFunctionRotateZ)
            arrow.addAnimation(anim, forKey:nil)

        case 10:
            // put them all together, they spell Mother...
            
            // capture current value, set final value
            let rot = M_PI/4.0
            CATransaction.setDisableActions(true)
            let current = arrow.valueForKeyPath("transform.rotation.z") as! Double
            arrow.setValue(current + rot, forKeyPath:"transform.rotation.z")

            // first animation (rotate and clunk)
            let anim1 = CABasicAnimation(keyPath:"transform")
            anim1.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim1.timingFunction = clunk
            anim1.fromValue = current
            anim1.toValue = current + rot
            anim1.valueFunction = CAValueFunction(name:kCAValueFunctionRotateZ)

            // second animation (waggle)
            var values = [0.0]
            for (var i = 20, direction = 1.0; i < 60; i += 5, direction *= -1) { // alternate directions
                values.append( direction * M_PI / Double(i) )
            }
            values.append(0.0)
            let anim2 = CAKeyframeAnimation(keyPath:"transform")
            anim2.values = values
            anim2.duration = 0.25
            anim2.additive = true
            anim2.beginTime = anim1.duration - 0.1
            anim2.valueFunction = CAValueFunction(name: kCAValueFunctionRotateZ)

            // group
            let group = CAAnimationGroup()
            group.animations = [anim1, anim2]
            group.duration = anim1.duration + anim2.duration
            arrow.addAnimation(group, forKey:nil)

            
        default: break
        }
    }
    
}
