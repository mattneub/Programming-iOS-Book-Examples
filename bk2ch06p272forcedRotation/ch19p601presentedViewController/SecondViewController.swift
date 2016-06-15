

import UIKit


protocol SecondViewControllerDelegate : class {
    func accept(data:AnyObject!)
}

class SecondViewController : UIViewController {
    
    var data : AnyObject?
    
    weak var delegate : SecondViewControllerDelegate?
    
    @IBAction func doDismiss(_ sender:AnyObject?) {
        self.presentingViewController!.dismiss(animated:true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // prove you've got data
        print(self.data)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed() {
            self.delegate?.accept(data:"Even more important data!")
        }
    }
    
    /* 
    ability of presented view controller to force app rotation
    missing in initial seeds of iOS 8, restored in seed 4
*/

    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        print("second supported")
        return .landscape
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    override func viewWillLayoutSubviews() {
        print("presented will layout")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("presented size")
        super.viewWillTransition(to: size, with: coordinator)
    }

    
}
