

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


class ViewController : UIViewController {
    var sprite : CALayer!
    lazy var images = self.makeImages()
    
    func makeImages () -> [UIImage] {
        var arr = [UIImage]()
        let sprites = UIImage(named: "sprites.png")!
        for i in [0,1,2,1,0] {
            let r = UIGraphicsImageRenderer(size:CGSize(24,24), format:sprites.imageRendererFormat)
            arr += [r.image { _ in
                sprites.draw(at:CGPoint(CGFloat(-(5+i)*24), -4*24))
            }]
        }
        return arr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sprite = CALayer()
        self.sprite.frame = CGRect(30,30,24,24)
        self.sprite.contentsScale = UIScreen.main.scale
        self.view.layer.addSublayer(self.sprite)
        self.sprite.contents = self.images[0].cgImage
        
    }
    
    @IBAction func doButton(_ sender: Any?) {
        
        self.sprite.removeAllAnimations()
        
        delay(0.1) { // if you remove all animations you have to do this, I don't know why

            let anim = CAKeyframeAnimation(keyPath:#keyPath(CALayer.contents))
            anim.values = self.images.map {$0.cgImage!}
            anim.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
            anim.calculationMode = .discrete
            anim.duration = 1.5
            anim.repeatCount = .greatestFiniteMagnitude
            
            let anim2 = CABasicAnimation(keyPath:#keyPath(CALayer.position))
            anim2.duration = 10
            anim2.toValue = CGPoint(350,30)
            
            let group = CAAnimationGroup()
            group.animations = [anim, anim2]
            group.duration = 10
            
            self.sprite.add(group, forKey:nil)
            
        }

        
    }
    
}
