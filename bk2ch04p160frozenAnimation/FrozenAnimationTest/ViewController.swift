

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var v: UIView!
    var shape : CAShapeLayer!
    
    override func viewDidLoad() {
        let shape = CAShapeLayer()
        shape.frame = v.bounds
        v.layer.addSublayer(shape)
        
        shape.fillColor = UIColor.clear().cgColor
        shape.strokeColor = UIColor.red().cgColor
        
        let path = CGPath(rect:shape.bounds, transform:nil)
        shape.path = path
        
        let path2 = CGPath(ellipseIn:shape.bounds, transform:nil)
        let ba = CABasicAnimation(keyPath:#keyPath(CAShapeLayer.path))
        ba.duration = 1
        ba.fromValue = path
        ba.toValue = path2
        
        shape.speed = 0
        shape.timeOffset = 0
        shape.add(ba, forKey: nil)
        
        self.shape = shape
        
    }
    
    @IBAction func doSlider(_ slider: UISlider) {
        self.shape.timeOffset = Double(slider.value)
    }

}

