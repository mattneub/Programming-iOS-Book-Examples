

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController : UIViewController, UIToolbarDelegate {
    var oldChoice : Int = -1
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    @IBAction func unwind (sender:UIStoryboardSegue) {
        if sender.identifier == "cancel" {
            NSUserDefaults.standardUserDefaults().setInteger(self.oldChoice, forKey: "choice")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
        self.oldChoice = NSUserDefaults.standardUserDefaults().integerForKey("choice")
    }
}

extension ViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // try swapping these; it works
        if traitCollection.horizontalSizeClass == .Compact {
            return .FullScreen
            // return .None
        }
        return .None
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        NSUserDefaults.standardUserDefaults().setInteger(self.oldChoice, forKey: "choice")
    }

}


