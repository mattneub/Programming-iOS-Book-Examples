

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
        println(data)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("vc did disappear")
    }
    
    override func supportedInterfaceOrientations() -> Int  {
        println("first supported")
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func viewWillLayoutSubviews() {
        println("presenter will layout")
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("presenter size")
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
}
