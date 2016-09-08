
import UIKit

class DetailViewController : UIViewController {
    var detailItem : Any?
    @IBOutlet var iv : UIImageView!
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let im = self.detailItem as? UIImage {
            self.iv.image = im
        }
        
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
