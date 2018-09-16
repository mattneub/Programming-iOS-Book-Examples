

import UIKit

class ViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    @IBOutlet weak var lab: UILabel!
    let dic = UIDocumentInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // prove that we can open a document
        let docurl = Bundle.main.url(forResource: "test", withExtension: "textaroonie")!
        let doc = MyDocument(fileURL: docurl)
        doc.open { _ in
            self.lab.text = doc.string
        }
        // if we opened the document, interface will say
        // "This is a success"
    }

    @IBAction func doShowPreview(_ sender: Any) {
        let docurl = Bundle.main.url(forResource: "test", withExtension: "textaroonie")!
        self.dic.url = docurl
        self.dic.delegate = self
        self.dic.presentPreview(animated:true)
        // "This is a success" on simulator, but
        // "This is a failure" on device
        // Proves that we are failing to open the UIDocument on the device
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

}

