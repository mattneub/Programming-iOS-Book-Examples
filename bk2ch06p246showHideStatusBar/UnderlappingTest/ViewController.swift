
import UIKit

class ViewController: UIViewController {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(self.view.bounds.size)
        print(self.navigationController!.view.bounds.size)
    }
    
    var hide = false
    
    override func prefersStatusBarHidden() -> Bool {
        return self.hide
    }

    @IBAction func doButton(_ sender: AnyObject) {
        self.hide = !self.hide
        UIView.animate(withDuration:0.4, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
        })
    }
}

