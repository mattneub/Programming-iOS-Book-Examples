
import UIKit

extension NSAttributedString.Key {
    static let myDate = NSAttributedString.Key(rawValue:"myDate")
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doUpdateLabel(nil)
    }
    
    @IBOutlet var lab : UILabel!
    
    @IBAction func doUpdateLabel(_ sender: Any?) {
        let mas = NSMutableAttributedString(attributedString:self.lab.attributedText!)
        let r = (mas.string as NSString).range(of:"^0")
        if r.length > 0 {
            mas.addAttribute(.myDate, value: 1, range: r)
            mas.replaceCharacters(in:r, with: Date().description)
        } else {
            mas.enumerateAttribute(.myDate, in: NSMakeRange(0, mas.length)) {
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
