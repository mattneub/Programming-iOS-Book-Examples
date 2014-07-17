
import UIKit

class DetailViewController : UIViewController {
    var detailItem : AnyObject?
    @IBOutlet var detailDescriptionLabel : UILabel
    
    override func viewDidLoad() {
        self.detailDescriptionLabel.text = "\(self.detailItem)"
    }
    
    
}
