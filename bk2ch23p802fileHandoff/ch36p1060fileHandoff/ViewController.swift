

import UIKit
import QuickLook

class ViewController: UIViewController, UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource {

    @IBOutlet var wv : UIWebView!
    var doc : URL?
    var docs = [URL]()
    let dic = UIDocumentInteractionController()
    let exts : Set<String> = ["pdf", "txt"]
    
    func displayDoc (url:URL) {
        print("displayDoc: \(url)")
        self.doc = url
        let req = URLRequest(url: url)
        self.wv.loadRequest(req)
    }
    
    func locateDoc () -> URL? {
        var url : URL? = nil
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dir = fm.enumerator(at: docsurl, includingPropertiesForKeys: nil)!
            for case let f as URL in dir {
                if self.exts.contains(f.pathExtension) {
                    url = f
                    break
                }
            }
        } catch {
            print(error)
        }
        return url
    }
    
    @IBAction func doDisplayDoc(_ sender: Any) {
        var url = self.doc
        if url == nil {
            url = self.locateDoc()
        }
        if url == nil {
            print("no doc")
            return
        }
        self.displayDoc(url: url!)
    }
    
    @IBAction func doHandOffDoc (_ sender: Any) {
        var url = self.doc
        if url == nil {
            url = self.locateDoc()
        }
        if url == nil {
            print("no doc")
            return
        }
        self.dic.url = url
        let v = sender as! UIView
        self.dic.delegate = self
        var which : Int { return 1 }
        switch which {
        case 1:
            let ok = self.dic.presentOpenInMenu(from:v.bounds, in: v, animated: true)
            if !ok {
                print("That didn't work out")
            }
        case 2:
            let ok = self.dic.presentOptionsMenu(from: v.bounds, in: v, animated: true)
            if !ok {
                print("That didn't work out")
            }
        default: break
        }
    }
    
    @IBAction func doPreview (_ sender: Any!) {
        var url = self.doc
        if url == nil {
            url = self.locateDoc()
        }
        if url == nil {
            print("no doc")
            return
        }
        print(url as Any)
        self.dic.url = url
        self.dic.delegate = self
        self.dic.presentPreview(animated:true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    @IBAction func doPreviewMultipleUsingQuickLook (_ sender: Any!) {
        self.docs = [URL]()
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dir = fm.enumerator(at: docsurl, includingPropertiesForKeys: nil)!
            for case let f as URL in dir {
                if self.exts.contains(f.pathExtension) {
                    if QLPreviewController.canPreview(f as QLPreviewItem) {
                        print("adding \(f)")
                        self.docs.append(f)
                    }
                }
            }
            guard self.docs.count > 0 else {
                print("no docs")
                return
            }
            // show preview interface
            let preview = QLPreviewController()
            preview.dataSource = self
            preview.currentPreviewItemIndex = 0
            self.present(preview, animated: true)
        } catch {
            print(error)
        }
    }
    
    
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return self.docs.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.docs[index] as QLPreviewItem
    }


    
}
