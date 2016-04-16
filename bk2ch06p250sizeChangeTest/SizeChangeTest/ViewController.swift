
func delay(_ delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

import UIKit

// demonstrating that a size change without rotation is not notified to the view controller
// I find this rather odd, but I suppose it's because this is not a transition coordinator situation
// (i.e. rotation)

class ViewController: UIViewController {

    @IBAction func doButton(_ sender: AnyObject) {
        print(self.view.bounds.size)
        let nav = self.navigationController!
        nav.isNavigationBarHidden = !nav.isNavigationBarHidden
        delay(1) {
            print("size did in fact change")
            print(self.view.bounds.size)
        }
    }
    
    /*
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        print("will rotate") // not called if viewWillTransitionToSize is implemented
    }
*/
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with: coordinator)
        print("size will transition")
        print(size)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print("trait collection changed")
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to:newCollection, with: coordinator)
        print("trait collection will transition")
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        print("update view constraints")
    }
    
    override func viewWillLayoutSubviews() {
        print("will layout")
    }


}

