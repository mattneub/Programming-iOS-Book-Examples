
import UIKit
import CoreImage.CIFilterBuiltins


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
        // lay.compositingFilter = CIFilter.differenceBlendMode() // nope
        // not animatable as far as I can tell
        return;
        // this is the example from the docs:
        do {
            lay.removeFromSuperlayer()
            let filter = CIFilter(name:"CIGaussianBlur")!
            filter.name = "myFilter"
            let lay2 = CALayer()
            lay2.frame = self.view.bounds
            lay2.backgroundFilters = [filter]
            lay2.setValue(20, forKeyPath: "backgroundFilters.myFilter.inputRadius")
            self.view.layer.addSublayer(lay2)
            // but as you can see, on iOS this does not magically cause the text view
            // to appear, blurred, behind the layer
        }
    }

}

