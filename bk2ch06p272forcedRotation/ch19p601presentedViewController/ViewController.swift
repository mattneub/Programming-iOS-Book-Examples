

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    @IBAction func doPresent(_ sender: Any?) {
        let svc = SecondViewController(nibName:"SecondViewController", bundle:nil)
//        svc.modalPresentationCapturesStatusBarAppearance = true
        svc.data = "This is very important data!"
        svc.delegate = self
//        svc.view.alpha = 0.5
        // in iOS 13, we must ask for fullScreen or overFullScreen
        // if we want forced rotation;
        // otherwise we get the sheet which doesn't force it
        // in my opinion overFullScreen looks better
        // but you don't get preferredInterfaceOrientationForPresentation
        // so there's a bug somewhere here
        svc.modalPresentationStyle = .overFullScreen
        svc.modalPresentationStyle = .fullScreen
//        svc.modalPresentationStyle = .pageSheet
        self.present(svc, animated:true)
        
    }
    
    func accept(data:Any) {
        // do something with data here
        
        // prove that you received data
        print(data)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("vc did disappear")
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask  {
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
