

import UIKit

func delay(_ delay:Double, closure:()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.after(when: when, execute: closure)
}

class ViewController : UIViewController, UIToolbarDelegate {
    var oldChoice : Int = -1

    func positionForBar(forBar bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController
        if let pop = dest.popoverPresentationController {
            pop.delegate = self
        }
        self.oldChoice = NSUserDefaults.standard().integer(forKey:"choice")
    }
    
    @IBAction func unwind (_ sender:UIStoryboardSegue) {
        if sender.identifier == "cancel" {
            NSUserDefaults.standard().set(self.oldChoice, forKey: "choice")
        }
    }
}

extension ViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("here3")
        if traitCollection.horizontalSizeClass == .compact {
            return .fullScreen
        }
        return .none
    }
    
    // but this doesn't work; my guess is that we have gone out of existence at this point
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        print("here4") // not called, this could be a bug
        NSUserDefaults.standard().set(self.oldChoice, forKey: "choice")
    }

}


