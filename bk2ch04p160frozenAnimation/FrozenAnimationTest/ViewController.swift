

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var v: UIView!
    var shape : CAShapeLayer!
    
    override func viewDidLoad() {
        let shape = CAShapeLayer()
        shape.frame = v.bounds
        v.layer.addSublayer(shape)
        
        shape.fillColor = UIColor.clearColor().CGColor
        shape.strokeColor = UIColor.redColor().CGColor
        
        let path = CGPathCreateWithRect(shape.bounds, nil)
        shape.path = path
        
        let path2 = CGPathCreateWithEllipseInRect(shape.bounds, nil)
        let ba = CABasicAnimation(keyPath: "path")
        ba.duration = 1
        ba.fromValue = path
        ba.toValue = path2
        
        shape.speed = 0
        shape.timeOffset = 0
        shape.addAnimation(ba, forKey: nil)
        
        self.shape = shape
        
    }
    
    @IBAction func doSlider(sender: AnyObject) {
        let slider = sender as! UISlider
        self.shape.timeOffset = Double(slider.value)
    }

}

