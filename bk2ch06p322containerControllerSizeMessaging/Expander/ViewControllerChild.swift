

import UIKit

class ViewControllerChild: UIViewController {
    
    var expanded = false
    
    init() {
        super.init(nibName: "ViewControllerChild", bundle: nil)
        self.preferredContentSize = CGSizeMake(250,250)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    @IBAction func doButton(sender: AnyObject) {
        // magically trigger communication with parent
        print("child setting preferred content size")
        self.preferredContentSize = self.expanded ? CGSizeMake(250,250) : CGSizeMake(350,350)
        self.expanded = !self.expanded
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("I am the child and my new size will be \(size)")
    }

}
