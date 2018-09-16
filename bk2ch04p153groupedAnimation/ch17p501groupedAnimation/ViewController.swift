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


class ViewController : UIViewController {
    var v : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.v = UIView(frame:CGRect(254,28,56,38))
        self.view.addSubview(self.v)
        self.v.layer.contents = UIImage(named:"boat.gif")!.cgImage
        self.v.layer.contentsGravity = .resizeAspectFill
    }
    
    @IBAction func doButton (_ sender: Any?) {
        self.animate()
    }
    
    func animate() {
        let h : CGFloat = 200
        let v : CGFloat = 75
        let path = CGMutablePath()
        var leftright : CGFloat = 1
        var next : CGPoint = self.v.layer.position
        var pos : CGPoint
        path.move(to:CGPoint(next.x, next.y))
        for _ in 0 ..< 4 {
            pos = next
            leftright *= -1
            next = CGPoint(pos.x+h*leftright, pos.y+v)
            path.addCurve(to:CGPoint(next.x, next.y),
                control1: CGPoint(pos.x, pos.y+30),
                control2: CGPoint(next.x, next.y-30))
        }
        let anim1 = CAKeyframeAnimation(keyPath:#keyPath(CALayer.position))
        anim1.path = path
        anim1.calculationMode = .paced
        
        let revs = [0.0, .pi, 0.0, .pi]
        let anim2 = CAKeyframeAnimation(keyPath:#keyPath(CALayer.transform))
        anim2.values = revs
        anim2.valueFunction = CAValueFunction(name:.rotateY)
        anim2.calculationMode = .discrete

        let pitches = [0.0, .pi/60.0, 0.0, -.pi/60.0, 0.0]
        let anim3 = CAKeyframeAnimation(keyPath:#keyPath(CALayer.transform))
        anim3.values = pitches
        anim3.repeatCount = .greatestFiniteMagnitude
        anim3.duration = 0.5
        anim3.isAdditive = true
        anim3.valueFunction = CAValueFunction(name:.rotateZ)

        let group = CAAnimationGroup()
        group.animations = [anim1, anim2, anim3]
        group.duration = 8
        self.v.layer.add(group, forKey:nil)
        CATransaction.setDisableActions(true)
        self.v.layer.position = next

    }
}
