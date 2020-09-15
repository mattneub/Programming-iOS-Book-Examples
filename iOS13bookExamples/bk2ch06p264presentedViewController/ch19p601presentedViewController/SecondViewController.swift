

import UIKit

/* 

Standard architecture for handing info from vc to presented vc...
...and back when presented vc is dismissed

*/

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


protocol SecondViewControllerDelegate : AnyObject {
    func accept(data:Any)
}

class SecondViewController : UIViewController {
    
    static var count = 0
    
    var data : Any?
    
    // rotation honored in full screen and over full screen
    // status bar honored only in full screen
    
//    override var shouldAutorotate: Bool {
//        print("should autorotate") // just checking to see when this is called
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        print("supported interface orientations returning portrait")
//        return .portrait
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        print("prefers status bar hidden true")
//        return true
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        print("prefers status bar light")
//        return .lightContent
//    }
    
    weak var delegate : SecondViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // just testing what multiple page sheets look like; quite nice actually
//        Self.count += 1
//        delay(3) {
//            if Self.count < 2 {
//                self.present(SecondViewController(), animated:true)
//            }
//        }
        // could be useful to know what's really behind us
        // try this in landscape iPhone, proves that .pageSheet is treated like .overFullScreen
        self.view.backgroundColor = UIColor.red.withAlphaComponent(0.7)
    }
    
    var which : Int = 2 // 1 or 2; 1 is flawed
    
    @IBAction func doDismiss(_ sender: Any) {
        print("dismiss button")
        // logging to show relationships
        print(self.presentingViewController!)
        print(self.presentingViewController!.presentedViewController as Any)
        let vc = self.delegate as! UIViewController
        print(vc.presentedViewController as Any)
        
        
        // just proving it works
//        self.dismiss(animated:true)
//        vc.dismiss(animated:true)
//        return;
        
        if which == 1 {
            // this works for the button, but not for drag to dismiss
            self.delegate?.accept(data:"Even more important data!")
        }
        self.presentingViewController?.dismiss(animated:true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // prove you've got data
        print(self.data as Any)
        // also explore size class situation
        print(self.traitCollection)
        
        // workaround for curl bug
        // return;
        if let grs = self.view.gestureRecognizers {
            for g in grs {
                if NSStringFromClass(type(of:g)).hasSuffix("CurlUpTapGestureRecognizer") {
                    g.isEnabled = false
                }
            }
        }
        // print("parent", self.parent as Any)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("will disappear?")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isBeingDismissed {
            if which == 2 {
                self.delegate?.accept(data:"Even more important data!")
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("new size coming: \(size)")
    }
    
    
}
