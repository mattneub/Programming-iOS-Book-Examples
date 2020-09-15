

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class ViewController : UIViewController, UIToolbarDelegate {
    var oldChoice : Int = -1
    
    @IBAction func doTapItem(_ sender: Any) {
        print("tap")
    }
    

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination
        if let pop = dest.popoverPresentationController {
            pop.delegate = self
        }
        self.oldChoice = UserDefaults.standard.integer(forKey:"choice")
    }
    
    @IBAction func unwind (_ sender:UIStoryboardSegue) {
        if sender.identifier == "cancel" {
            UserDefaults.standard.set(self.oldChoice, forKey: "choice")
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
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        print("here4")
        UserDefaults.standard.set(self.oldChoice, forKey: "choice")
    }

}


