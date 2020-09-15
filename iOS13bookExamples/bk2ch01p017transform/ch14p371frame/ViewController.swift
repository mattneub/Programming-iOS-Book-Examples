

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var which : Int {return 5}
        
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
            
            let rect = CGRect(113, 111, 132, 194)
            let shift = CGAffineTransform(translationX: -rect.midX, y: -rect.midY)
            let rotate = v1.transform
            let transform = shift.concatenating(rotate).concatenating(shift.inverted())
            let rect2 = rect.applying(transform)
            print(rect2)
            
            
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
            v2.transform = t.concatenating(r) // not r.concatenating(t)
            
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
            
        case 8:
            // transform3D now available on view
            let v1 = UIView(frame:CGRect(113, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds.insetBy(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            self.view.addSubview(v1)
            v1.addSubview(v2)
            
            v1.transform3D = CATransform3DMakeRotation(.pi/4, 1, 0, 0)
            
            // not very good code but if we don't do something like this
            // ... we don't get any depth
            var transform = CATransform3DIdentity
            transform.m34 = -1.0/500.0
            self.view.layer.sublayerTransform = transform

        case 9:
            // transform3D now available on view
            let v1 = UILabel(frame:CGRect(113, 111, 132, 194))
            v1.numberOfLines = 0
            v1.text = "Hello, world"
            v1.sizeToFit()
            self.view.addSubview(v1)
            
            
            delay(2) {
                UIView.animate(withDuration: 2) {
                    // is it animatable?
                    // yes sir it is
                    v1.transform3D = CATransform3DMakeRotation(.pi, 0, 1, 0)
                    // v1.transform3D = CATransform3DMakeRotation(.pi/4, 1, 0, 0)

                }
            }

//            var transform = CATransform3DIdentity
//            transform.m34 = -1.0/500.0
//            self.view.layer.sublayerTransform = transform


        default: break
        }
        
        

        
    }


}
