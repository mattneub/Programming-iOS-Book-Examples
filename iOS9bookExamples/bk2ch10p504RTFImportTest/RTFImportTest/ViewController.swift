
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tv: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSBundle.mainBundle().URLForResource("test", withExtension: "rtf")!
        let opts = [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType]
        var d : NSDictionary? = nil
        let s = try! NSAttributedString(URL: url, options: opts, documentAttributes: &d)
        self.tv.attributedText = s
    }


}

