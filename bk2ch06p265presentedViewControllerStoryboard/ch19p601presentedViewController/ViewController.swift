

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    // the segue in the storyboard is drawn directly from the button...
    // so SecondViewController will be instantiated for us...
    // and "presentViewController" will be called for us
    // thus we need another place to configure
    
    // old way; this will _still_ be called even if segue action is called
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if #available(iOS 13.0, *) {
            return
        } else {
            if segue.identifier == "present" { // it will be
                let svc = segue.destination as! SecondViewController
                svc.data = "This is very important data!"
                svc.delegate = self
            }
        }
    }
    
    // new in iOS 13
    // we are still not told the class; that is now in fact up to us
    // which makes this architecture more like the no-storyboard architecture
    @IBSegueAction func presentSecondViewController(_ coder:NSCoder, sender:Any?, ident:String?) -> UIViewController? {
        if let svc = SecondViewController(coder:coder) {
            svc.data = "This is very important data!"
            svc.delegate = self
            return svc
        }
        return nil
    }
    
    func accept(data:Any) {
        // do something with data here
        
        // prove that you received data
        print(data as Any)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("vc did disappear")
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("here") // prove that this is called by clicking on curl
        super.dismiss(animated:animated, completion: completion)
    }
    
    
}
