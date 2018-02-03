

import UIKit


func delay(_ delay:Double, closure:@escaping ()->()) {
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
            // abandon use of NSLog here, because it now truncates; not even sure why I was using it
            let s = String(format: "\n\n%@\nH: %@\nV:%@", vv, arr1, arr2)
            print(s)
            if vv.subviews.count > 0 {
                self.listConstraints(vv)
            }
        }
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    weak var lab1: UILabel!
    weak var lab2: UILabel!

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let lab1 = UILabel(frame:CGRect(270,20,42,22))
        lab1.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        lab1.text = "Hello"
        self.view.addSubview(lab1)
        self.lab1 = lab1
        print(button, button.translatesAutoresizingMaskIntoConstraints, terminator:"\n\n")
        print(lab1, lab1.translatesAutoresizingMaskIntoConstraints, terminator:"\n\n")
        
        let lab2 = UILabel()
        lab2.translatesAutoresizingMaskIntoConstraints = false
        lab2.text = "Howdy"
        self.view.addSubview(lab2)
        self.lab2 = lab2
        print(lab2, lab2.translatesAutoresizingMaskIntoConstraints, terminator:"\n\n")

        
        // pin second label to first one
        
        NSLayoutConstraint.activate([
            lab2.topAnchor.constraint(equalTo: lab1.bottomAnchor, constant: 20),
            lab2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
            ])
        
        // we also have a button; what if we pin the second label to that as well?
        NSLayoutConstraint.activate([
            lab2.widthAnchor.constraint(equalTo: button.widthAnchor)
            ])


        delay(2) {
            // show lab2 info again after layout
            print(lab2, lab2.translatesAutoresizingMaskIntoConstraints, terminator:"\n\n")

            NSLayoutConstraint.listConstraints(nil)
            
        }
    }

}

