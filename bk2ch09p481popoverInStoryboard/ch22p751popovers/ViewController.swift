

import UIKit

func delay(_ delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController : UIViewController, UIToolbarDelegate {
    var oldChoice : Int = -1
    
    func position(forBar bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    @IBAction func unwind (_ sender:UIStoryboardSegue) {
        if sender.identifier == "cancel" {
            NSUserDefaults.standard().set(self.oldChoice, forKey: "choice")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue)
        if segue.identifier == "MyPopover" {
            let dest = segue.destinationViewController
            if let pop = dest.popoverPresentationController {
                pop.delegate = self
                delay(0.1) {
                    pop.passthroughViews = nil
                }
                // pop.permittedArrowDirections = [.Up, .Down]
            }
        }
        self.oldChoice = NSUserDefaults.standard().integer(forKey:"choice")
    }
}

extension ViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // try swapping these; it works
        if traitCollection.horizontalSizeClass == .compact {
            return .fullScreen
            // return .none
        }
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        NSUserDefaults.standard().set(self.oldChoice, forKey: "choice")
    }

}


