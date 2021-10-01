
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let outline: CGPath = {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 10, y: 27))
            path.addCurve(to: CGPoint(x: 40, y: 27), control1: CGPoint(x: 12, y: 27), control2: CGPoint(x: 28.02, y: 27))
            path.addCurve(to: CGPoint(x: 27, y: 02), control1: CGPoint(x: 55.92, y: 27), control2: CGPoint(x: 50.47, y: 2))
            path.addCurve(to: CGPoint(x: 2, y: 27), control1: CGPoint(x: 13.16, y: 2), control2: CGPoint(x: 2, y: 13.16))
            path.addCurve(to: CGPoint(x: 27, y: 52), control1: CGPoint(x: 2, y: 40.84), control2: CGPoint(x: 13.16, y: 52))
            path.addCurve(to: CGPoint(x: 52, y: 27), control1: CGPoint(x: 40.84, y: 52), control2: CGPoint(x: 52, y: 40.84))
            path.addCurve(to: CGPoint(x: 27, y: 2), control1: CGPoint(x: 52, y: 13.16), control2: CGPoint(x: 42.39, y: 2))
            path.addCurve(to: CGPoint(x: 2, y: 27), control1: CGPoint(x: 13.16, y: 2), control2: CGPoint(x: 2, y: 13.16))
            
            return path
        }()
        let lay = CAShapeLayer()
        lay.path = outline
        lay.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        lay.fillColor = nil
        lay.strokeColor = UIColor.black.cgColor
        lay.lineCap = .round
        lay.lineWidth = 10
        lay.strokeStart = 0
        lay.strokeEnd = 0.1
        self.view.layer.addSublayer(lay)
        
        delay(3) {
            CATransaction.begin()
            CATransaction.setAnimationDuration(2)
            lay.strokeEnd = 1
            lay.strokeStart = 0.25
            CATransaction.commit()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

