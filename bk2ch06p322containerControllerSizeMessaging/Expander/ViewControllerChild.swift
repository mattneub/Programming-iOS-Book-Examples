

import UIKit

class ViewControllerChild: UIViewController {
    
    var expanded = false
    
    init() {
        super.init(nibName: "ViewControllerChild", bundle: nil)
        self.preferredContentSize = CGSize(250,250)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    @IBAction func doButton(_ sender: Any) {
        // magically trigger communication with parent
        print("child setting preferred content size")
        self.preferredContentSize = self.expanded ? CGSize(250,250) : CGSize(350,350)
        self.expanded = !self.expanded
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("I am the child and my new size will be \(size)")
    }

}
