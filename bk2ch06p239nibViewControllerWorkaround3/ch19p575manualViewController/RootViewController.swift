
import UIKit

class RootViewController : UIViewController {
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init() {
        super.init(nibName:"RootViewController", bundle:nil)
    }
    
}
