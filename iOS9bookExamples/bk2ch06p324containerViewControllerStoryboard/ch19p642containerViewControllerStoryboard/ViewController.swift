

import UIKit

class ViewController: UIViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepare")
        if segue.identifier == "embed" {
            NSLog("%@ %@ %@", segue.identifier!, segue.sourceViewController, segue.destinationViewController)
            NSLog("%d", segue.destinationViewController.isViewLoaded())
            NSLog("%@", segue.sourceViewController.childViewControllers)
            NSLog("%@", self.childViewControllers)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("did load %@ %@", self.view, self.childViewControllers)
        // NSLog(@"%d", [self.childViewControllers[0] isViewLoaded]);
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("did appear %@ %@", self.view, self.childViewControllers)
    }

}

class ChildViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("child did load %@ %@", self.view, self.childViewControllers)
        // NSLog(@"%d", [self.childViewControllers[0] isViewLoaded]);
        
    }

}
