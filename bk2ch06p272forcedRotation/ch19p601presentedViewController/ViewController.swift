

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    @IBAction func doPresent(_ sender:AnyObject?) {
        let svc = SecondViewController(nibName:"SecondViewController", bundle:nil)
        svc.data = "This is very important data!"
        svc.delegate = self
//        svc.view.alpha = 0.5
//        svc.modalPresentationStyle = .OverFullScreen
        self.present(svc, animated:true, completion:nil)
        
    }
    
    func accept(data:AnyObject!) {
        // do something with data here
        
        // prove that you received data
        print(data)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("vc did disappear")
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask  {
        print("first supported")
        return .portrait
    }
    
    override func viewWillLayoutSubviews() {
        print("presenter will layout")
    }
    
    // not called in iOS 9, and I guess this makes a kind of sense
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("presenter size")
        super.viewWillTransition(to: size, with: coordinator)
    }
    
}
