

import UIKit

class ViewControllerChild: UIViewController {
    
    var expanded = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.preferredContentSize = CGSizeMake(250,250)
    }
    
    @IBAction func doButton(sender: AnyObject) {
        // magically trigger communication with parent
        self.preferredContentSize = self.expanded ? CGSizeMake(250,250) : CGSizeMake(350,350)
        self.expanded = !self.expanded
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator!) {
        println("I am the child and my new size will be \(size)")
    }

}
