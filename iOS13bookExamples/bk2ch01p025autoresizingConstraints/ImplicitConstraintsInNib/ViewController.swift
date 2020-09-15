

import UIKit

extension NSLayoutConstraint {
    func activate(withIdentifier id: String) {
        (self.identifier, self.isActive) = (id, true)
    }
}


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

@objc extension UIView {
    func reportAmbiguity(filtering:Bool = false) {
        let has = self.hasAmbiguousLayout
        if has || !filtering {
            print(self, has)
        }
        for sub in self.subviews {
            sub.reportAmbiguity(filtering:filtering)
        }
    }
}

@objc extension UIView {
    func listConstraints(recursing:Bool = true, up:Bool = false, filtering:Bool = false) {
        let arr1 = self.constraintsAffectingLayout(for:.horizontal)
        let arr2 = self.constraintsAffectingLayout(for:.vertical)
        var arr = arr1 + arr2
        if filtering {
            arr = arr.filter{
                $0.firstItem as? UIView == self ||
                    $0.secondItem as? UIView == self }
        }
        if !arr.isEmpty {
            print(self); arr.forEach { print($0) }; print()
        }
        guard recursing else { return }
        if !up { // down
            for sub in self.subviews {
                sub.listConstraints(up:up)
            }
        } else { // up
            self.superview?.listConstraints(up:up)
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
        print(button as Any, button.translatesAutoresizingMaskIntoConstraints, terminator:"\n\n")
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
            let `self` = self // for debugging at breakpoint
            print("delay", terminator:"\n\n")
            print(lab2, lab2.translatesAutoresizingMaskIntoConstraints, terminator:"\n\n")
        }
    }

}

