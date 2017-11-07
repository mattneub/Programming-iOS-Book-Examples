

import UIKit
import QuickLook

class PreviewViewController: UIViewController, QLPreviewingController {
    @IBOutlet weak var lab: UILabel!
    
    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        let doc = MyDocument(fileURL: url)
        doc.open { _ in
            self.lab.text = doc.string
            handler(nil)
        }
    }
    
}
