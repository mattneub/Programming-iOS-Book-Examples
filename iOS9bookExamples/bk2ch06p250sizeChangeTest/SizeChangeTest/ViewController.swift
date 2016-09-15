
func delay(delay:Double, closure:()->()) {
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

    @IBAction func doButton(sender: AnyObject) {
        print(self.view.bounds.size)
        let nav = self.navigationController!
        nav.navigationBarHidden = !nav.navigationBarHidden
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
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print("size will transition")
        print(size)
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print("trait collection changed")
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
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

