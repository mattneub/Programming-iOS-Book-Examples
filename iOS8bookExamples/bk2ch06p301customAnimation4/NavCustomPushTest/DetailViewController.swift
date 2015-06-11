
import UIKit

class DetailViewController : UIViewController {
    var detailItem : AnyObject?
    @IBOutlet var detailDescriptionLabel : UILabel!
    
    override func viewDidLoad() {
        self.detailDescriptionLabel.text = "\(self.detailItem)"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("\(self) " + __FUNCTION__)
        if let tc = self.transitionCoordinator() {
            println(tc)
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("\(self) " + __FUNCTION__)
        if let tc = self.transitionCoordinator() {
            println(tc)
        }
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("\(self) " + __FUNCTION__)
        
        if let tc = self.transitionCoordinator() {
            println(tc)
        }
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("\(self) " + __FUNCTION__)
        if let tc = self.transitionCoordinator() {
            println(tc)
        }
        
    }

}
