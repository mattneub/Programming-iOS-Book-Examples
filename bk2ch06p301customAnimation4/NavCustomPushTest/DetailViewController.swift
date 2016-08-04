
import UIKit

class DetailViewController : UIViewController {
    var detailItem : AnyObject?
    @IBOutlet var detailDescriptionLabel : UILabel!
    
    override func viewDidLoad() {
        self.detailDescriptionLabel.text = "\(self.detailItem)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) " + #function)
        
        if let tc = self.transitionCoordinator {
            print(tc)
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
        
    }

}
