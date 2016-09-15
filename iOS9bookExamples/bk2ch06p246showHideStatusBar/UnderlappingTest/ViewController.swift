
import UIKit

class ViewController: UIViewController {

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print(self.view.bounds.size)
        print(self.navigationController!.view.bounds.size)
    }
    
    var hide = false
    
    override func prefersStatusBarHidden() -> Bool {
        return self.hide
    }

    @IBAction func doButton(sender: AnyObject) {
        self.hide = !self.hide
        UIView.animateWithDuration(0.4, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
        })
    }
}

