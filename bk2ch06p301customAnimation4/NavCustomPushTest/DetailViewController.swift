
import UIKit

class DetailViewController : UIViewController {
    var detailItem : AnyObject?
    @IBOutlet var detailDescriptionLabel : UILabel!
    
    override func viewDidLoad() {
        self.detailDescriptionLabel.text = "\(self.detailItem)"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) " + __FUNCTION__)
        if let tc = self.transitionCoordinator() {
            print(tc)
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) " + __FUNCTION__)
        if let tc = self.transitionCoordinator() {
            print(tc)
        }
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) " + __FUNCTION__)
        
        if let tc = self.transitionCoordinator() {
            print(tc)
        }
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) " + __FUNCTION__)
        if let tc = self.transitionCoordinator() {
            print(tc)
        }
        
    }

}
