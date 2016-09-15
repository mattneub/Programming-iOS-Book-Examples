
import UIKit


class MyView: UIView {
    
    var layer1: CALayer!
    var layer2a: CALayer!
    var layer2b: CALayer!
    
    override class func layerClass() -> AnyClass {
        return CATransformLayer.self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        let lay = CALayer()
        lay.frame = self.bounds
        //lay.backgroundColor = [UIColor redColor].CGColor;
        self.layer.addSublayer(lay)
        self.layer1 = lay
        let lay2 = CALayer()
        lay2.frame = CGRectInset(self.bounds, 30,30)
        lay2.backgroundColor = UIColor.greenColor().CGColor
        lay2.shadowOffset = CGSizeMake(8,8)
        lay2.shadowRadius = 12
        lay2.shadowColor = UIColor.grayColor().CGColor
        lay2.shadowOpacity = 0.8
        lay2.zPosition = -10
        self.layer1.addSublayer(lay2)
        self.layer2a = lay2
        let lay3 = CALayer()
        lay3.frame = CGRectOffset(self.layer2a.bounds, 40, 40)
        lay3.backgroundColor = UIColor.yellowColor().CGColor
        lay3.shadowOffset = CGSizeMake(8,8)
        lay3.shadowRadius = 12
        lay3.shadowColor = UIColor.grayColor().CGColor
        lay3.shadowOpacity = 0.8
        lay3.zPosition = 30
        self.layer1.addSublayer(lay3)
        self.layer2b = lay3
        lay3.contents = UIImage(named:"jet.png")!.CGImage

    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
