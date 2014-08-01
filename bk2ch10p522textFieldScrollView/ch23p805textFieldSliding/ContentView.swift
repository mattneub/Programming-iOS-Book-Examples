
import UIKit
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ContentView: UIView {
    
    // workaround broken content sizing of scroll views by constraints in iOS 8
    // what a mess

    override func intrinsicContentSize() -> CGSize {
        println("intrinsic")
        return self.superview.bounds.size
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection!) {
        println("trait")
        delay(0) {
            self.invalidateIntrinsicContentSize()
        }
    }

}
