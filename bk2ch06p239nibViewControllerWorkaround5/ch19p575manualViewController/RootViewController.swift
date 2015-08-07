
import UIKit

class RootViewController : UIViewController {
    override var nibName : String {
        get {
            return "RootView" // Note: _not_ "RootViewController" - not stripped magically
        }
    }
}
