

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var which : Int {return 6}
        
        switch which {
        case 1:
            let v1 = UIView(frame:CGRect(113, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds.insetBy(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            self.view.addSubview(v1)
            v1.addSubview(v2)
            
            v1.transform = CGAffineTransform(rotationAngle:45 * .pi/180)
            print(v1.frame)
            
        case 2:
            let v1 = UIView(frame:CGRect(113, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds.insetBy(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            self.view.addSubview(v1)
            v1.addSubview(v2)
            
            v1.transform = CGAffineTransform(scaleX:1.8, y:1)
            
        case 3:
            let v1 = UIView(frame:CGRect(20, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds)
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            self.view.addSubview(v1)
            v1.addSubview(v2)
            
            v2.transform = CGAffineTransform(translationX:100, y:0).rotated(by: 45 * .pi/180)
            
        case 4:
            let v1 = UIView(frame:CGRect(20, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds)
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            self.view.addSubview(v1)
            v1.addSubview(v2)
            
            v2.transform = CGAffineTransform(rotationAngle:45 * .pi/180).translatedBy(x: 100, y: 0)
            
        case 5: // same as case 4 but using concat
            let v1 = UIView(frame:CGRect(20, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds)
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            self.view.addSubview(v1)
            v1.addSubview(v2)
            
            let r = CGAffineTransform(rotationAngle:45 * .pi/180)
            let t = CGAffineTransform(translationX:100, y:0)
            v2.transform = t.concatenating(r) // not r.concat(t)
            
        case 6:
            let v1 = UIView(frame:CGRect(20, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds)
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            self.view.addSubview(v1)
            v1.addSubview(v2)
            
            let r = CGAffineTransform(rotationAngle:45 * .pi/180)
            let t = CGAffineTransform(translationX:100, y:0)
            v2.transform = t.concatenating(r)
            v2.transform = r.inverted().concatenating(v2.transform)
            
        case 7:
            let v1 = UIView(frame:CGRect(113, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds.insetBy(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            self.view.addSubview(v1)
            v1.addSubview(v2)
            
            v1.transform = CGAffineTransform(a:1, b:0, c:-0.2, d:1, tx:0, ty:0)
            
        default: break
        }
        
        

        
    }


}
