
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tv: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "test", withExtension: "rtf")!
        let opts : [NSAttributedString.DocumentReadingOptionKey : Any] =
            [.documentType : NSAttributedString.DocumentType.rtf]
        let s = try! NSAttributedString(url: url, options: opts, documentAttributes: nil)
        self.tv.attributedText = s
    }


}

