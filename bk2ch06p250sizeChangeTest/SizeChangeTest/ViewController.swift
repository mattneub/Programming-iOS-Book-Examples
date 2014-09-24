
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
        let nav = self.navigationController!
        nav.navigationBarHidden = !nav.navigationBarHidden
        delay(1) {
            println("size did in fact change")
            println(self.view.bounds.size)
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("size will change")
        println(size)
    }


}

