

import UIKit


@objc protocol SecondViewControllerDelegate {
    func acceptData(data:AnyObject!)
}

class SecondViewController : UIViewController {
    
    var data : AnyObject?
    
    weak var delegate : SecondViewControllerDelegate?
    
    @IBAction func doDismiss(sender:AnyObject?) {
        self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // prove you've got data
        println(self.data)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed() {
            self.delegate?.acceptData("Even more important data!")
        }
    }
    
    /* 
    This is the biggest and most far-reaching breakage in iOS 8 that I have found so far.
    A presented view controller can no longer dictate the accepted orientations of the app
    at the moment it appears
    (and the presenting view controller can no longer dictate the accepted orientations
    at the moment the presented view controller is dismissed).
    I have not found any workaround.
*/

    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Landscape.toRaw())
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeLeft
    }
    
    override func viewWillLayoutSubviews() {
        println("presented will layout")
    }
    
}
