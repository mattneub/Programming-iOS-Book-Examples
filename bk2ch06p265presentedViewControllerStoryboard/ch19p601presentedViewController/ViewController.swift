

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    // the segue in the storyboard is drawn directly from the button...
    // so SecondViewController will be instantiated for us...
    // and "presentViewController" will be called for us
    // thus we need another place to configure
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "present" { // it will be
            let svc = segue.destination as! SecondViewController
            svc.data = "This is very important data!"
            svc.delegate = self
        }
    }
    
    func accept(data:Any!) {
        // do something with data here
        
        // prove that you received data
        print(data)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("vc did disappear")
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)!) {
        print("here") // prove that this is called by clicking on curl
        super.dismiss(animated:animated, completion: completion)
    }
    
    
}
