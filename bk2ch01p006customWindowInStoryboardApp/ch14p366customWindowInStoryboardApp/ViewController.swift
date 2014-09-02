
import UIKit

class ViewController : UIViewController {
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        println(self.view.window!)
        println(UIApplication.sharedApplication().delegate!.window!!) // kind of wacky, there, Swift
        println((UIApplication.sharedApplication().delegate as AppDelegate).window)
        println(UIApplication.sharedApplication().keyWindow)
    }
}
