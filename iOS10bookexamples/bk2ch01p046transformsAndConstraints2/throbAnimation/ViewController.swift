

import UIKit

/*
The bug with transform view animations is also gone in iOS 8!

In iOS 7 and before,
the first view jumps to the side when we perform our scale animation.
The workaround is commented out:
The second view is configured the same way; we prevent it from jumping
by taking it out of the influence of autolayout, which is hardly satisfactory.
For one thing, we get a complaint from the autolayout system...
...unless we also temporarily remove the second view's internal constraints.
*/

class ViewController: UIViewController {

    @IBOutlet var v1 : UIView!
    @IBOutlet var v2 : UIView!
    var constraints : [NSLayoutConstraint]!
    
    override func viewDidLoad()  {
        super.viewDidLoad()
    }
    
    @IBAction func doTest(_ sender: Any?) {
//        self.v2.setTranslatesAutoresizingMaskIntoConstraints(true)
//        self.constraints = self.v2.constraints() as NSLayoutConstraint[]
//        self.v2.removeConstraints(self.constraints)

        UIView.animate(withDuration:0.4, delay: 0,
            options: .autoreverse,
            animations: {
                self.v1.transform = CGAffineTransform(scaleX:1.1, y:1.1)
                self.v2.transform = CGAffineTransform(scaleX:1.1, y:1.1)
            }, completion: {
                _ in
                self.v1.transform = .identity
                self.v2.transform = .identity

//                self.v2.addConstraints(self.constraints)
//                self.v2.setTranslatesAutoresizingMaskIntoConstraints(false)
            })
    }

}
