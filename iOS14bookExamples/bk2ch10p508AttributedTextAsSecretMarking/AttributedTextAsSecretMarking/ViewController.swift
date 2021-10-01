
import UIKit

extension NSAttributedString.Key {
    static let date = NSAttributedString.Key("date")
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
            mas.addAttribute(.date, value: 1, range: r)
            mas.replaceCharacters(in:r, with: Date().description)
        } else {
            mas.enumerateAttribute(.date, in: NSMakeRange(0, mas.length)) { val, r, stop in
                if val as? Int == 1 {
                    mas.replaceCharacters(in:r, with: Date().description)
                    stop.pointee = true
                }
            }
        }
        self.lab.attributedText = mas
    }


}
