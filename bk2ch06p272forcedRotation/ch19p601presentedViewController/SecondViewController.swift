

import UIKit


protocol SecondViewControllerDelegate : class {
    func accept(data:Any!)
}

class SecondViewController : UIViewController {
    
    var data : Any?
    
    weak var delegate : SecondViewControllerDelegate?
    
    @IBAction func doDismiss(_ sender: Any?) {
        self.presentingViewController?.dismiss(animated:true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // prove you've got data
        print(self.data as Any)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed {
            self.delegate?.accept(data:"Even more important data!")
        }
    }
    
    /* 
    ability of presented view controller to force app rotation
    missing in initial seeds of iOS 8, restored in seed 4
*/

    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        print("second supported")
        return .landscape
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
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
