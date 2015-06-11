

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    @IBAction func doPresent(sender:AnyObject?) {
        
        
        let svc = SecondViewController(nibName: "SecondViewController", bundle: nil)
        svc.data = "This is very important data!"
        svc.delegate = self
        
        svc.modalPresentationStyle = .FormSheet

        svc.presentationController!.delegate = self // *
        
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
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)!) {
        println("here") // prove that this is called by clicking on curl
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    
}

extension ViewController : UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        println("adapt!")
        return .OverFullScreen
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let newvc = ThirdViewController(nibName: "ThirdViewController", bundle: nil)
        newvc.data = "This is very important data!"
        newvc.delegate = self

        println("newvc!")
        return newvc
    }

}
