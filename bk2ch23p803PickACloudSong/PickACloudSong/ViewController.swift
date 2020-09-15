

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
        //let picker = UIDocumentPickerViewController(documentTypes: [kUTTypeMP3 as String, "com.neuburg.pplgrp"], in: .import)
        let types: [UTType] = {
            if let type = UTType("com.neuburg.pplgrp") {
                return [UTType.mp3, type]
            } else {
                return [UTType.mp3]
            }
        }()
        switch which {
        case 0:
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
            picker.delegate = self
            self.present(picker, animated: true)
        case 1:
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
            picker.delegate = self
            self.present(picker, animated: true)
        case 2:
            // not in the book, just testing
            let url = Bundle.main.url(forResource: "lib", withExtension: "jpg")!
            let fm = FileManager.default
            let docs = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let newurl = docs.appendingPathComponent("lib.jpg")
            try? fm.copyItem(at: url, to: newurl)
            let picker = UIDocumentPickerViewController(forExporting: [url])
            self.present(picker, animated: true, completion: nil)
        default: break
        }
    }
    
    var which : Int { 2 }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        switch which {
        case 0:
            guard urls.count == 1 else {return}
            guard let vals = try? urls[0].resourceValues(forKeys: [.typeIdentifierKey]), vals.typeIdentifier == UTType.mp3.identifier else {return}
            let vc = AVPlayerViewController()
            vc.player = AVPlayer(url: urls[0])
            self.present(vc, animated: true) { vc.player?.play() }
            print(urls[0])
        case 1:
            guard urls.count == 1 else {return}
            guard urls[0].startAccessingSecurityScopedResource() else { return }
            guard let vals = try? urls[0].resourceValues(forKeys: [.typeIdentifierKey]), vals.typeIdentifier == UTType.mp3.identifier else {return}
            let vc = AVPlayerViewController()
            vc.player = AVPlayer(url: urls[0])
            self.present(vc, animated: true) { vc.player?.play() }
            print(urls[0])
            urls[0].stopAccessingSecurityScopedResource()
        case 2:
            // not in the book
            print(urls[0])
        default: break
        }
    }


}

