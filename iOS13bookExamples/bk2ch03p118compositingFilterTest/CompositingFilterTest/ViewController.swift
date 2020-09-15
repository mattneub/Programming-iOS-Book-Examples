
import UIKit

// this has worked at least since iOS 10, but it is undocumented...
// ...and indeed the docs claim it doesn't exist

// for a better example, see https://github.com/arthurschiller/CompositingFilters

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let lay = CAGradientLayer()
        lay.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        lay.frame = self.view.bounds
        self.view.layer.addSublayer(lay)
        lay.compositingFilter = "differenceBlendMode" // !! a string, not a filter
        // not animatable as far as I can tell
    }

}

