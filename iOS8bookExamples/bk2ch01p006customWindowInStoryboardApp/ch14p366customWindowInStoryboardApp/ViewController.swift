
import UIKit

class ViewController : UIViewController {
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        println(self.view.window!)
        println(UIApplication.sharedApplication().delegate!.window!!) // kind of wacky, there, Swift
        println((UIApplication.sharedApplication().delegate as! AppDelegate).window!)
        println(UIApplication.sharedApplication().keyWindow!)
        println(UIApplication.sharedApplication().windows.count) // prove there's just the one, ours
    }
    
    // for end of chapter 5 example
    
    override func viewDidLoad() {
        let mainview = self.view
        let lay1 = CALayer()
        lay1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1).CGColor
        lay1.frame = CGRectMake(113, 111, 132, 194)
        mainview.layer.addSublayer(lay1)
        let lay2 = CALayer()
        lay2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1).CGColor
        lay2.frame = CGRectMake(41, 56, 132, 194)
        lay1.addSublayer(lay2)
        let lay3 = CALayer()
        lay3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).CGColor
        lay3.frame = CGRectMake(43, 197, 160, 230)
        mainview.layer.addSublayer(lay3)

    }
}
