

import UIKit

class ViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if segue.identifier == "embed" {
            NSLog("%@ %@ %@", segue.identifier!, segue.source, segue.destination)
            NSLog("%@", segue.destination.isViewLoaded as NSNumber)
            NSLog("%@", segue.source.childViewControllers)
            NSLog("%@", self.childViewControllers)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("did load %@ %@", self.view, self.childViewControllers)
        // NSLog(@"%d", [self.childViewControllers[0] isViewLoaded]);
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
