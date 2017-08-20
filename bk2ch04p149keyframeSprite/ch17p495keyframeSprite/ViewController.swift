

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
    var sprite : CALayer!
    lazy var images = self.makeImages()
    
    func makeImages () -> [UIImage] {
        var arr = [UIImage]()

        for i in [0,1,2,1,0] {
            let r = UIGraphicsImageRenderer(size:CGSize(24,24))
            arr += [r.image { _ in
                UIImage(named: "sprites.png")!.draw(at:CGPoint(CGFloat(-(5+i)*24), -4*24))
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

        let anim = CAKeyframeAnimation(keyPath:#keyPath(CALayer.contents))
        anim.values = self.images.map {$0.cgImage!}
        anim.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        anim.calculationMode = kCAAnimationDiscrete
        anim.duration = 1.5
        anim.repeatCount = .infinity
        
        let anim2 = CABasicAnimation(keyPath:#keyPath(CALayer.position))
        anim2.duration = 10
        anim2.toValue = CGPoint(350,30)
        
        let group = CAAnimationGroup()
        group.animations = [anim, anim2]
        group.duration = 10
        
        self.sprite.add(group, forKey:nil)

        
    }
    
}
