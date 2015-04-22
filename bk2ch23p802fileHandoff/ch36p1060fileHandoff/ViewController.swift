

import UIKit
import QuickLook

class ViewController: UIViewController, UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource {

    @IBOutlet var wv : UIWebView!
    var doc : NSURL!
    var docs : [NSURL]!
    let dic = UIDocumentInteractionController()
    let exts = ["pdf", "txt"]
    
    func displayDoc (url:NSURL) {
        println("displayDoc: \(url)")
        self.doc = url
        let req = NSURLRequest(URL: url)
        self.wv.loadRequest(req)
    }
    
    func locateDoc () -> NSURL? {
        var url : NSURL? = nil
        let fm = NSFileManager()
        var err : NSError?
        let docsurl = fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: &err)
        let dir = fm.enumeratorAtURL(docsurl!, includingPropertiesForKeys: nil, options: nil, errorHandler: nil)
        while let f = dir?.nextObject() as? NSURL {
            if find(self.exts, f.pathExtension!) != nil {
                url = f
                break
            }
        }
        return url
    }
    
    @IBAction func doDisplayDoc(sender: AnyObject) {
        var url = self.doc
        if url == nil {
            url = self.locateDoc()
        }
        if url == nil {
            println("no doc")
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
            println("no doc")
            return
        }
        self.dic.URL = url
        let v = sender as! UIView
        let ok = self.dic.presentOpenInMenuFromRect(v.bounds, inView: v, animated: true)
        if !ok {
            println("That didn't work out")
        }
    }
    
    @IBAction func doPreview (sender:AnyObject!) {
        var url = self.doc
        if url == nil {
            url = self.locateDoc()
        }
        if url == nil {
            println("no doc")
            return
        }
        println(url)
        self.dic.URL = url
        self.dic.delegate = self
        self.dic.presentPreviewAnimated(true)
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    @IBAction func doPreviewMultipleUsingQuickLook (sender:AnyObject!) {
        self.docs = [NSURL]()
        let fm = NSFileManager()
        var err : NSError?
        let docsurl = fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: &err)
        let dir = fm.enumeratorAtURL(docsurl!, includingPropertiesForKeys: nil, options: nil, errorHandler: nil)
        while let f = dir?.nextObject() as? NSURL {
            if find(self.exts, f.pathExtension!) != nil {
                if QLPreviewController.canPreviewItem(f) {
                    println("adding \(f)")
                    self.docs.append(f)
                }
            }
        }
        if self.docs.count == 0 {
            println("no docs")
            return
        }
        // show preview interface
        let preview = QLPreviewController()
        preview.dataSource = self
        preview.currentPreviewItemIndex = 0
        self.presentViewController(preview, animated: true, completion: nil)
    }
    
    
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController!) -> Int {
        return self.docs.count
    }
    
    func previewController(controller: QLPreviewController!, previewItemAtIndex index: Int) -> QLPreviewItem! {
        return self.docs[index]
    }


    
}
