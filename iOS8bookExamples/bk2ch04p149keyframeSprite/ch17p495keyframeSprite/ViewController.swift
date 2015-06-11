

import UIKit


class ViewController : UIViewController {
    var sprite : CALayer!
    lazy var images : [UIImage] = self.makeImages()
    
    func makeImages () -> [UIImage] {
        var arr = [UIImage]()
        for (var i = 0; i < 3; i++) {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(24,24), true, 0)
            UIImage(named: "sprites.png")!.drawAtPoint(CGPointMake(CGFloat(-(5+i)*24), -4*24))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            arr += [im]
        }
        for (var i = 1; i >= 0; i--) {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(24,24), true, 0)
            UIImage(named: "sprites.png")!.drawAtPoint(CGPointMake(CGFloat(-(5+i)*24),-4*24))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            arr += [im]
        }
        return arr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sprite = CALayer()
        self.sprite.frame = CGRectMake(30,30,24,24)
        self.sprite.contentsScale = UIScreen.mainScreen().scale
        self.view.layer.addSublayer(self.sprite)
        self.sprite.contents = self.images[0].CGImage
        
    }
    
    @IBAction func doButton(sender:AnyObject?) {

        let anim = CAKeyframeAnimation(keyPath:"contents")
        anim.values = self.images.map {$0.CGImage as AnyObject}
        anim.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        anim.calculationMode = kCAAnimationDiscrete
        anim.duration = 1.5
        anim.repeatCount = Float.infinity
        
        let anim2 = CABasicAnimation(keyPath:"position")
        anim2.duration = 10
        anim2.toValue = NSValue(CGPoint: CGPointMake(350,30))
        
        let group = CAAnimationGroup()
        group.animations = [anim, anim2]
        group.duration = 10
        
        self.sprite.addAnimation(group, forKey:nil)

        
    }
    
}
