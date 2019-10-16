

import UIKit
import QuickLook

class PreviewViewController: UIViewController, QLPreviewingController {
    @IBOutlet weak var lab: UILabel!
    
    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        
        // this was my first attempt; it fails on the device with a filecoordinatord crash
//        doc.open { _ in
//            self.lab.text = doc.string
//            handler(nil)
//        }

        // so then I tried this, and to my amazement it worked
        // it feels illegal, though, because I'm not using a file coordinator
        
//        DispatchQueue.global(qos: .background).async {
//            let doc = MyDocument(fileURL: url)
//            do {
//                try doc.read(from: url)
//                DispatchQueue.main.async {
//                    self.lab.text = doc.string
//                }
//                handler(nil)
//            } catch {
//                handler(error)
//            }
//        }
        
        // so then I tried it this way
        // I like this better because at least I'm using a file coordinator
        
        let fc = NSFileCoordinator()
        let intent = NSFileAccessIntent.readingIntent(with: url)
        let queue = OperationQueue()
        fc.coordinate(with: [intent], queue: queue) { err in
            do {
                let data = try Data(contentsOf: intent.url)
                let doc = MyDocument(fileURL: url)
                try doc.load(fromContents: data, ofType: nil)
                DispatchQueue.main.async {
                    self.lab.text = doc.string
                }
                handler(nil)
            } catch {
                handler(error)
            }
        }
    }
    
}
