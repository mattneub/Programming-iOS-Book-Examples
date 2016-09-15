

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
        let req = NSURLRequest(URL: url)
        self.wv.loadRequest(req)
    }
    
    func locateDoc () -> NSURL? {
        var url : NSURL? = nil
        do {
            let fm = NSFileManager()
            let docsurl = try fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let dir = fm.enumeratorAtURL(docsurl, includingPropertiesForKeys: nil, options: [], errorHandler: nil)!
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
    
    @IBAction func doDisplayDoc(sender: AnyObject) {
        var url = self.doc
        if url == nil {
            url = self.locateDoc()
        }
        if url == nil {
            print("no doc")
            return
        }
        self.displayDoc(url)
    }
    
    @IBAction func doHandOffDoc (sender:AnyObject) {
        var url = self.doc
        if url == nil {
            url = self.locateDoc()
        }
        if url == nil {
            print("no doc")
            return
        }
        self.dic.URL = url
        let v = sender as! UIView
        self.dic.delegate = self
        let ok = self.dic.presentOpenInMenuFromRect(v.bounds, inView: v, animated: true)
        // let ok = self.dic.presentOptionsMenuFromRect(v.bounds, inView: v, animated: true)
        if !ok {
            print("That didn't work out")
        }
    }
    
    @IBAction func doPreview (sender:AnyObject!) {
        var url = self.doc
        if url == nil {
            url = self.locateDoc()
        }
        if url == nil {
            print("no doc")
            return
        }
        print(url)
        self.dic.URL = url
        self.dic.delegate = self
        self.dic.presentPreviewAnimated(true)
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    @IBAction func doPreviewMultipleUsingQuickLook (sender:AnyObject!) {
        self.docs = [NSURL]()
        do {
            let fm = NSFileManager()
            let docsurl = try fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let dir = fm.enumeratorAtURL(docsurl, includingPropertiesForKeys: nil, options: [], errorHandler: nil)!
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
            self.presentViewController(preview, animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
    
    
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return self.docs.count
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
        return self.docs[index]
    }


    
}
