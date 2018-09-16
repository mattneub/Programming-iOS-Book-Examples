

import UIKit


class ViewController : UIViewController {
    @IBOutlet var compassView : CompassView!
    
    let which = 1

    @IBAction func doButton(_ sender: Any?) {
        let c = self.compassView.layer as! CompassLayer
        let arrow = c.arrow!
        
        switch which {
        case 1:
            // proving that cornerRadius is _not_ implicitly animatable
            CATransaction.setAnimationDuration(2)
            c.masksToBounds = true
            c.cornerRadius = 50

            // this is actual content of the example
            arrow.transform = CATransform3DRotate(arrow.transform, .pi/4.0, 0, 0, 1)

        case 2:
            // new in iOS 11, corner radius is animatable under view animation
            // but only if it is a view's layer
            // and nothing else seems to be; it's some kind of special dispensation
            // note e.g. that the arrow is animated too, but not over the 5-second duration
            c.masksToBounds = true
            arrow.masksToBounds = true
            let anim = UIViewPropertyAnimator(duration: 5, timingParameters: UICubicTimingParameters())
            anim.addAnimations {
                arrow.transform = CATransform3DRotate(arrow.transform, .pi/4.0, 0, 0, 1)
                arrow.cornerRadius = 50
                c.cornerRadius = 50
            }
            anim.startAnimation()
            
        case 3:
            CATransaction.setAnimationDuration(0.8)
            arrow.transform = CATransform3DRotate(arrow.transform, .pi/4.0, 0, 0, 1)
            
        case 4:
            let clunk = CAMediaTimingFunction(controlPoints: 0.9, 0.1, 0.7, 0.9)
            CATransaction.setAnimationTimingFunction(clunk)
            arrow.transform = CATransform3DRotate(arrow.transform, .pi/4.0, 0, 0, 1)

        case 5:
            // proving that the completion block works
            CATransaction.setCompletionBlock({
                print("done")
                })
            
            // capture the start and end values
            let startValue = arrow.transform
            let endValue = CATransform3DRotate(startValue, .pi/4.0, 0, 0, 1)
            // change the layer, without implicit animation
            CATransaction.setDisableActions(true)
            arrow.transform = endValue
            // construct the explicit animation
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim.timingFunction = clunk
            anim.fromValue = startValue
            anim.toValue = endValue
            // ask for the explicit animation
            arrow.add(anim, forKey:nil)
            
        case 6:
            CATransaction.setDisableActions(true)
            arrow.transform = CATransform3DRotate(arrow.transform, .pi/4.0, 0, 0, 1)
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim.timingFunction = clunk
            arrow.add(anim, forKey:nil)
            
        case 7:
            // capture the start and end values
            let nowValue = arrow.transform
            let startValue = CATransform3DRotate(nowValue, .pi/40.0, 0, 0, 1)
            let endValue = CATransform3DRotate(nowValue, -.pi/40.0, 0, 0, 1)
            // construct the explicit animation
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.05
            anim.timingFunction = CAMediaTimingFunction(name:.linear)
            anim.repeatCount = 3
            anim.autoreverses = true
            anim.fromValue = startValue
            anim.toValue = endValue
            // ask for the explicit animation
            arrow.add(anim, forKey:nil)
            
        case 8:
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.05
            anim.timingFunction =
                CAMediaTimingFunction(name:.linear)
            anim.repeatCount = 3
            anim.autoreverses = true
            anim.isAdditive = true
            anim.valueFunction = CAValueFunction(name:.rotateZ)
            anim.fromValue = Float.pi/40
            anim.toValue = -Float.pi/40
            arrow.add(anim, forKey:nil)
            
        case 9:
            let rot = CGFloat.pi/4.0
            CATransaction.setDisableActions(true)
            arrow.transform = CATransform3DRotate(arrow.transform, rot, 0, 0, 1)
            // construct animation additively
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim.timingFunction = clunk
            anim.fromValue = -rot
            anim.toValue = 0
            anim.isAdditive = true
            anim.valueFunction = CAValueFunction(name:.rotateZ)
            arrow.add(anim, forKey:nil)

        case 10:
            var values = [0.0]
            let directions = sequence(first:1) {$0 * -1}
            let bases = stride(from: 20, to: 60, by: 5)
            for (base, dir) in zip(bases, directions) {
                values.append(Double(dir) * .pi / Double(base))
            }
            values.append(0.0)
            print(values)
            let anim = CAKeyframeAnimation(keyPath:#keyPath(CALayer.transform))
            anim.values = values
            anim.isAdditive = true
            anim.valueFunction = CAValueFunction(name:.rotateZ)
            arrow.add(anim, forKey:nil)

        case 11:
            // put them all together, they spell Mother...
            
            // capture current value, set final value
            let rot = .pi/4.0
            CATransaction.setDisableActions(true)
            let current = arrow.value(forKeyPath:"transform.rotation.z") as! Double
            arrow.setValue(current + rot, forKeyPath:"transform.rotation.z")

            // first animation (rotate and clunk)
            let anim1 = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim1.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim1.timingFunction = clunk
            anim1.fromValue = current
            anim1.toValue = current + rot
            anim1.valueFunction = CAValueFunction(name:.rotateZ)

            // second animation (waggle)
            var values = [0.0]
            let directions = sequence(first:1) {$0 * -1}
            let bases = stride(from: 20, to: 60, by: 5)
            for (base, dir) in zip(bases, directions) {
                values.append(Double(dir) * .pi / Double(base))
            }
            values.append(0.0)
            let anim2 = CAKeyframeAnimation(keyPath:#keyPath(CALayer.transform))
            anim2.values = values
            anim2.duration = 0.25
            anim2.isAdditive = true
            anim2.beginTime = anim1.duration - 0.1
            anim2.valueFunction = CAValueFunction(name: .rotateZ)

            // group
            let group = CAAnimationGroup()
            group.animations = [anim1, anim2]
            group.duration = anim1.duration + anim2.duration
            arrow.add(group, forKey:nil)

        case 12:
            // proving that cornerRadius was always explicitly animatable
            CATransaction.setDisableActions(true)
            c.masksToBounds = true
            c.cornerRadius = 50
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.cornerRadius))
            anim.duration = 5
            anim.fromValue = 0
            anim.toValue = 50
            c.add(anim, forKey:nil)

            
        default: break
        }
    }
    
}
