

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var which : Int {return 1}
        
        switch which {
        case 1:
            let v1 = UIView(frame:CGRect(113, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds.insetBy(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            self.view.addSubview(v1)
            v1.addSubview(v2)
            
        case 2:
            let v1 = UIView(frame:CGRect(113, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds.insetBy(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            self.view.addSubview(v1)
            v1.addSubview(v2)
            
            v2.bounds.size.height += 20
            v2.bounds.size.width += 20
            
        case 3:
            let v1 = UIView(frame:CGRect(113, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds.insetBy(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            self.view.addSubview(v1)
            v1.addSubview(v2)
            
            v1.bounds.origin.x += 10
            v1.bounds.origin.y += 10
            
        case 4:
            // showing how to center a view in its superview
            let v1 = UIView(frame:CGRect(113, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:CGRect(0,0,20,20))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            self.view.addSubview(v1)
            v1.addSubview(v2)
            v2.center = v1.convert(v1.center, from:v1.superview)
            
            
        default: break
        }
        

        
    }


}
