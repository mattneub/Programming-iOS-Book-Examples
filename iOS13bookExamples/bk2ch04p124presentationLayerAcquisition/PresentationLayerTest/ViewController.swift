

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

/*
 Revealing stages in the life of the presentation layer.
 
 Before the render tree is initially constructed around the layer, it has no presentation layer.
 
 It has a presentation layer after rendering; that is what is portrayed on the screen.
 
 During animation, it has a _different_ presentation layer.
 
 After animation, it has yet _another_ presentation layer.
 
 So the moral is: a layer that is visible on screen always has a presentation layer,
 because that's what _is_ visible;
 but don't expect this to be some one constant object.
 */

class MyLayer : CALayer {
    override func layoutSublayers() {
        print("here1")
        if let subs = self.sublayers {
            for lay in subs {
                print(lay.presentation() as Any)
            }
        }
        super.layoutSublayers()
        print("here2")
        if let subs = self.sublayers {
            for lay in subs {
                print(lay.presentation() as Any)
            }
        }
    }
}
class MyView : UIView {
    override class var layerClass: AnyClass { return MyLayer.self }
}
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lay = CALayer()
        lay.backgroundColor = UIColor.black.cgColor
        lay.frame = CGRect(x: 10, y: 10, width: 10, height: 10)
        self.view.layer.addSublayer(lay)
        print(lay.presentation() as Any)
        delay(1) {
            print(lay.presentation() as Any)
            print("let's try rerendering")
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            delay(1) {
                print("let's try animating")
                let anim = CABasicAnimation(keyPath:"position")
                anim.duration = 1
                CATransaction.setCompletionBlock {
                    print("finished animation")
                    delay(0.1) {
                        print(lay.presentation() as Any)
                    }
                }
                anim.toValue = CGPoint(x:100,y:100)
                lay.add(anim, forKey: nil)
                delay(0.5) {
                    print("during animation")
                    print(lay.presentation() as Any)
                }
            }
        }
    }
}

