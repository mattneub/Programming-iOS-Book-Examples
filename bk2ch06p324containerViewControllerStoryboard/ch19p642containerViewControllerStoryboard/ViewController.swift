

import UIKit

class ViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepare")
        if segue.identifier == "embed" {
            NSLog("%@ %@ %@", segue.identifier! as NSObject, segue.sourceViewController, segue.destinationViewController)
            NSLog("%d", segue.destinationViewController.isViewLoaded() as NSNumber)
            NSLog("%@", segue.sourceViewController.childViewControllers as NSObject)
            NSLog("%@", self.childViewControllers as NSObject)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("did load %@ %@", self.view, self.childViewControllers as NSObject)
        // NSLog(@"%d", [self.childViewControllers[0] isViewLoaded]);
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("did appear %@ %@", self.view, self.childViewControllers as NSObject)
    }

}

class ChildViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("child did load %@ %@", self.view, self.childViewControllers as NSObject)
        // NSLog(@"%d", [self.childViewControllers[0] isViewLoaded]);
        
    }

}
