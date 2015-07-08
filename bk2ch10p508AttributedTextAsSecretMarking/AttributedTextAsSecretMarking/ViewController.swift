
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var lab : UILabel!
    
    @IBAction func doUpdateLabel(sender:AnyObject?) {
        let mas = self.lab.attributedText!.mutableCopy() as! NSMutableAttributedString
        let r = (mas.string as NSString).rangeOfString("^0")
        if r.length > 0 {
            mas.addAttribute("HERE", value: 1, range: r)
            mas.replaceCharactersInRange(r, withString: NSDate().description)
        } else {
            mas.enumerateAttribute("HERE", inRange: NSMakeRange(0, mas.length), options: []) {
                value, r, stop in
                if let value = value as? Int where value == 1 {
                    mas.replaceCharactersInRange(r, withString: NSDate().description)
                    stop.memory = true
                }
            }
        }
        self.lab.attributedText = mas
    }


}
