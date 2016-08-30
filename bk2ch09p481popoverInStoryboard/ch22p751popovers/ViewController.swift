

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class ViewController : UIViewController, UIToolbarDelegate {
    var oldChoice : Int = -1
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    @IBAction func unwind (_ sender:UIStoryboardSegue) {
        if sender.identifier == "cancel" {
            UserDefaults.standard.set(self.oldChoice, forKey: "choice")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue)
        if segue.identifier == "MyPopover" {
            let dest = segue.destination
            if let pop = dest.popoverPresentationController {
                pop.delegate = self
                delay(0.1) {
                    pop.passthroughViews = nil
                }
                // pop.permittedArrowDirections = [.Up, .Down]
            }
        }
        self.oldChoice = UserDefaults.standard.integer(forKey:"choice")
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
        UserDefaults.standard.set(self.oldChoice, forKey: "choice")
    }

}


