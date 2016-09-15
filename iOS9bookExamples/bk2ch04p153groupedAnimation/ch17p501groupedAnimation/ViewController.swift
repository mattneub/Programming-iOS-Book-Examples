import UIKit


class ViewController : UIViewController {
    var v : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.v = UIView(frame:CGRectMake(254,28,56,38))
        self.view.addSubview(self.v)
        self.v.layer.contents = UIImage(named:"boat.gif")!.CGImage
        self.v.layer.contentsGravity = kCAGravityResizeAspectFill
    }
    
    @IBAction func doButton (sender: AnyObject?) {
        self.animate()
    }
    
    func animate() {
        let h : CGFloat = 200
        let v : CGFloat = 75
        let path = CGPathCreateMutable()
        var leftright : CGFloat = 1
        var next : CGPoint = self.v.layer.position
        var pos : CGPoint
        CGPathMoveToPoint(path, nil, next.x, next.y)
        for _ in 0 ..< 4 {
            pos = next
            leftright *= -1
            next = CGPointMake(pos.x+h*leftright, pos.y+v)
            CGPathAddCurveToPoint(path, nil,
                pos.x, pos.y+30,
                next.x, next.y-30,
                next.x, next.y)
        }
        let anim1 = CAKeyframeAnimation(keyPath:"position")
        anim1.path = path
        anim1.calculationMode = kCAAnimationPaced
        
        let revs = [0.0, M_PI, 0.0, M_PI]
        let anim2 = CAKeyframeAnimation(keyPath:"transform")
        anim2.values = revs
        anim2.valueFunction = CAValueFunction(name:kCAValueFunctionRotateY)
        anim2.calculationMode = kCAAnimationDiscrete

        let pitches = [0.0, M_PI/60.0, 0.0, -M_PI/60.0, 0.0]
        let anim3 = CAKeyframeAnimation(keyPath:"transform")
        anim3.values = pitches
        anim3.repeatCount = Float.infinity
        anim3.duration = 0.5
        anim3.additive = true
        anim3.valueFunction = CAValueFunction(name:kCAValueFunctionRotateZ)

        let group = CAAnimationGroup()
        group.animations = [anim1, anim2, anim3]
        group.duration = 8
        self.v.layer.addAnimation(group, forKey:nil)
        CATransaction.setDisableActions(true)
        self.v.layer.position = next

    }
}
