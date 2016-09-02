
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var lab : UILabel!
    
    @IBAction func doUpdateLabel(_ sender:AnyObject?) {
        let mas = self.lab.attributedText!.mutableCopy() as! NSMutableAttributedString
        let r = (mas.string as NSString).range(of:"^0")
        if r.length > 0 {
            mas.addAttribute("HERE", value: 1, range: r)
            mas.replaceCharacters(in:r, with: Date().description)
        } else {
            mas.enumerateAttribute("HERE", in: NSMakeRange(0, mas.length)) {
                value, r, stop in
                if let value = value as? Int, value == 1 {
                    mas.replaceCharacters(in:r, with: Date().description)
                    stop.pointee = true
                }
            }
        }
        self.lab.attributedText = mas
    }


}
