

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController
        if let pop = dest.popoverPresentationController {
            pop.delegate = self
        }
        self.oldChoice = NSUserDefaults.standardUserDefaults().integerForKey("choice")
    }
    
    @IBAction func unwind (sender:UIStoryboardSegue) {
        if sender.identifier == "cancel" {
            NSUserDefaults.standardUserDefaults().setInteger(self.oldChoice, forKey: "choice")
        }
    }
}

extension ViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("here3")
        if traitCollection.horizontalSizeClass == .Compact {
            return .FullScreen
        }
        return .None
    }
    
    // but this doesn't work; my guess is that we have gone out of existence at this point
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        print("here4") // not called, this could be a bug
        NSUserDefaults.standardUserDefaults().setInteger(self.oldChoice, forKey: "choice")
    }

}


