

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit

// assume you've put an MP3 into the cloud somehow...

class ViewController: UIViewController, UIDocumentPickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // heh heh, I'll also use this to check whether I can see other stuff like people groups
    @IBAction func doButton(_ sender: Any) {
        let picker = UIDocumentPickerViewController(documentTypes: [kUTTypeMP3 as String, "com.neuburg.pplgrp"], in: .import)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard urls.count == 1 else {return}
        guard let vals = try? urls[0].resourceValues(forKeys: [.typeIdentifierKey]), vals.typeIdentifier == kUTTypeMP3 as String else {return}
        let vc = AVPlayerViewController()
        vc.player = AVPlayer(url: urls[0])
        self.present(vc, animated: true)
        print(urls[0])
    }


}

