

import UIKit

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



class ViewController: UIViewController {
    
    // simple example of lying to a child view controller about its trait environment
    // notice that the embedded version of ViewController2 is missing the Dismiss button!
    // that's because it thinks it has a Compact horizontal size class...
    // ...which is configured with a different interface in the storyboard
    
    override func viewDidLoad() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "vc2")
        self.addChild(vc) // "will" called for us
        let tc = UITraitCollection(horizontalSizeClass: .compact)
        self.setOverrideTraitCollection(tc, forChild: vc) // heh heh
        vc.view.frame = CGRect(100,100,200,200)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }


}

