

import UIKit

func delay(_ delay:Double, closure:()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


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

extension NSLayoutConstraint {
    class func reportAmbiguity (_ v:UIView?) {
        var v = v
        if v == nil {
            v = UIApplication.shared.keyWindow
        }
        for vv in v!.subviews {
            print("\(vv) \(vv.hasAmbiguousLayout)")
            if vv.subviews.count > 0 {
                self.reportAmbiguity(vv)
            }
        }
    }
    class func listConstraints (_ v:UIView?) {
        var v = v
        if v == nil {
            v = UIApplication.shared.keyWindow
        }
        for vv in v!.subviews {
            let arr1 = vv.constraintsAffectingLayout(for:.horizontal)
            let arr2 = vv.constraintsAffectingLayout(for:.vertical)
            NSLog("\n\n%@\nH: %@\nV:%@", vv, arr1, arr2);
            if vv.subviews.count > 0 {
                self.listConstraints(vv)
            }
        }
    }
}


class ViewController: UIViewController {

    weak var lab1: UILabel!
    weak var lab2: UILabel!

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let lab1 = UILabel(frame:CGRect(313,20,42,22))
        lab1.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        lab1.text = "Hello"
        self.view.addSubview(lab1)
        self.lab1 = lab1
        
        let lab2 = UILabel()
        lab2.translatesAutoresizingMaskIntoConstraints = false
        lab2.text = "Howdy"
        self.view.addSubview(lab2)
        self.lab2 = lab2

        
        // the way to test this is to add another label and pin to the first one
        
        NSLayoutConstraint.activate([
            lab2.topAnchor.constraint(equalTo: lab1.bottomAnchor, constant: 20),
            lab2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
            ])


        delay(2) {
            NSLayoutConstraint.listConstraints(nil)
            
        }
    }

}

