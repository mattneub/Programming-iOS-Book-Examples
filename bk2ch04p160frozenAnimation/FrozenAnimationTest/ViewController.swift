

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var v: UIView!
    var shape : CAShapeLayer!
    
    var which = 1 // 1 for layer freeze, 2 for animation freeze
    
    override func viewDidLoad() {
        let shape = CAShapeLayer()
        shape.frame = v.bounds
        v.layer.addSublayer(shape)
        
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.red.cgColor
        
        let path = CGPath(rect:shape.bounds, transform:nil)
        shape.path = path
        
        let path2 = CGPath(ellipseIn:shape.bounds, transform:nil)
        let ba = CABasicAnimation(keyPath:#keyPath(CAShapeLayer.path))
        ba.duration = 1
        ba.fromValue = path
        ba.toValue = path2
        
        switch which {
        case 1:
            shape.speed = 0
            shape.timeOffset = 0
        case 2:
            ba.speed = 0
            ba.timeOffset = 0
        default:break
        }
        shape.add(ba, forKey:#keyPath(CAShapeLayer.path))
        
        self.shape = shape
        
    }
    
    @IBAction func doSlider(_ slider: UISlider) {
        switch which {
        case 1:
            self.shape.timeOffset = Double(slider.value)
        case 2:
            // this seems to be how a property animator does it
            let anim = self.shape.animation(forKey:#keyPath(CAShapeLayer.path))
            let anim2 = anim?.copy() as! CAAnimation
            anim2.timeOffset = Double(slider.value)
            self.shape.add(anim2, forKey:#keyPath(CAShapeLayer.path))
        default:break
        }
    }

}

