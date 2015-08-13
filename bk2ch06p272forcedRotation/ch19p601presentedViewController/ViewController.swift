

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    @IBAction func doPresent(sender:AnyObject?) {
        let svc = SecondViewController(nibName:"SecondViewController", bundle:nil)
        svc.data = "This is very important data!"
        svc.delegate = self
//        svc.view.alpha = 0.5
//        svc.modalPresentationStyle = .OverFullScreen
        self.presentViewController(svc, animated:true, completion:nil)
        
    }
    
    func acceptData(data:AnyObject!) {
        // do something with data here
        
        // prove that you received data
        print(data)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("vc did disappear")
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask  {
        print("first supported")
        return .Portrait
    }
    
    override func viewWillLayoutSubviews() {
        print("presenter will layout")
    }
    
    // not called in iOS 9, and I guess this makes a kind of sense
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("presenter size")
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
}
