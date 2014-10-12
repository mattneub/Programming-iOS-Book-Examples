
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tv: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSBundle.mainBundle().URLForResource("test", withExtension: "rtf")!
        let opts = [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType]
        let s = NSAttributedString(fileURL: url, options: opts, documentAttributes: nil, error: nil)
        self.tv.attributedText = s
    }


}

