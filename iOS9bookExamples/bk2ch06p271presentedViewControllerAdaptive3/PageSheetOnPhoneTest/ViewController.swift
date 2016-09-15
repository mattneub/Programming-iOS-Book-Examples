

import UIKit

class ViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    var adaptiveType : UIModalPresentationStyle = .None
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print(controller.presentationStyle.rawValue)
        print(self.adaptiveType.rawValue)
        return self.adaptiveType
    }
    
    func presentationController(presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        print(style.rawValue)
    }
    
    // this seems incoherent to me
    // you can adapt PageSheet to None and get a page sheet...
    // but if you adapt PageSheet to PageSheet you get FullScreen?????
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let d = segue.destinationViewController
        if segue.identifier == "test1" {
            self.adaptiveType = .None
            d.presentationController!.delegate = self
        }
        if segue.identifier == "test2" {
            self.adaptiveType = .PageSheet
            d.presentationController!.delegate = self
        }
    }
    

    @IBAction func doDismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

