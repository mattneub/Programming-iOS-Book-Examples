
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
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class MyView: UIView {
    
    var layer1: CALayer!
    var layer2a: CALayer!
    var layer2b: CALayer!
    
    override class var layerClass: AnyClass {
        return CATransformLayer.self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        let lay = CALayer()
        lay.frame = self.bounds
        //lay.backgroundColor = [UIColor redColor].cgColor;
        self.layer.addSublayer(lay)
        self.layer1 = lay
        let lay2 = CALayer()
        lay2.frame = self.bounds.insetBy(dx: 30,dy: 30)
        lay2.backgroundColor = UIColor.green.cgColor
        lay2.shadowOffset = CGSize(8,8)
        lay2.shadowRadius = 12
        lay2.shadowColor = UIColor.gray.cgColor
        lay2.shadowOpacity = 0.8
        lay2.zPosition = -10
        self.layer1.addSublayer(lay2)
        self.layer2a = lay2
        let lay3 = CALayer()
        lay3.frame = self.layer2a.bounds.offsetBy(dx: 40, dy: 40)
        lay3.backgroundColor = UIColor.yellow.cgColor
        lay3.shadowOffset = CGSize(8,8)
        lay3.shadowRadius = 12
        lay3.shadowColor = UIColor.gray.cgColor
        lay3.shadowOpacity = 0.8
        lay3.zPosition = 30
        self.layer1.addSublayer(lay3)
        self.layer2b = lay3
        lay3.contents = UIImage(named:"jet.png")!.cgImage

    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        // Drawing code
    }
    */

}
