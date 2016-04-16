

import UIKit
import QuickLook

class ViewController: UIViewController, UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource {

    @IBOutlet var wv : UIWebView!
    var doc : NSURL!
    var docs : [NSURL]!
    let dic = UIDocumentInteractionController()
    let exts : Set<String> = ["pdf", "txt"]
    
    func displayDoc (url:NSURL) {
        print("displayDoc: \(url)")
        self.doc = url
        let req = NSURLRequest(url: url)
        self.wv.loadRequest(req)
    }
    
    func locateDoc () -> NSURL? {
        var url : NSURL? = nil
        do {
            let fm = NSFileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dir = fm.enumerator(at: docsurl, includingPropertiesForKeys: nil, options: [], errorHandler: nil)!
            for case let f as NSURL in dir {
                if self.exts.contains(f.pathExtension!) {
                    url = f
                    break
                }
            }
        } catch {
            print(error)
        }
        return url
    }
    
    @IBAction func doDisplayDoc(_ sender: AnyObject) {
        var url = self.doc
        if url == nil {
            url = self.locateDoc()
        }
        if url == nil {
            print("no doc")
            return
        }
        self.displayDoc(url:url)
    }
    
    @IBAction func doHandOffDoc (_ sender:AnyObject) {
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
        let ok = self.dic.presentOpenInMenu(from:v.bounds, in: v, animated: true)
        // let ok = self.dic.presentOptionsMenuFromRect(v.bounds, inView: v, animated: true)
        if !ok {
            print("That didn't work out")
        }
    }
    
    @IBAction func doPreview (_ sender:AnyObject!) {
        var url = self.doc
        if url == nil {
            url = self.locateDoc()
        }
        if url == nil {
            print("no doc")
            return
        }
        print(url)
        self.dic.url = url
        self.dic.delegate = self
        self.dic.presentPreview(animated:true)
    }
    
    func documentInteractionControllerViewController(forPreview controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    @IBAction func doPreviewMultipleUsingQuickLook (_ sender:AnyObject!) {
        self.docs = [NSURL]()
        do {
            let fm = NSFileManager()
            let docsurl = try fm.urlForDirectory(.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dir = fm.enumerator(at: docsurl, includingPropertiesForKeys: nil, options: [], errorHandler: nil)!
            for case let f as NSURL in dir {
                if self.exts.contains(f.pathExtension!) {
                    if QLPreviewController.canPreviewItem(f) {
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
            self.present(preview, animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
    
    
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return self.docs.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.docs[index]
    }


    
}
