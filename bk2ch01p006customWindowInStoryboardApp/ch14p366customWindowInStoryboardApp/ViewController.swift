
import UIKit

class ViewController : UIViewController {
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        println(self.view.window)
        println(UIApplication.sharedApplication().delegate.window)
        println(UIApplication.sharedApplication().keyWindow)
    }
}
