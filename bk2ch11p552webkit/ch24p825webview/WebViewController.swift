
import UIKit
import WebKit
import SafariServices

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


/*
A simple no-navigation web view - we just show our own custom content and that's all.
Demonstrates basic web kit configuration and some cool features.
*/

class MyMessageHandler : NSObject, WKScriptMessageHandler {
    weak var delegate : WKScriptMessageHandler?
    init(delegate:WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    func userContentController(userContentController: WKUserContentController,
        didReceiveScriptMessage message: WKScriptMessage) {
            delegate?.userContentController(userContentController, didReceiveScriptMessage: message)
    }
    deinit {
        print("message handler dealloc")
    }
}

class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, UIViewControllerRestoration, SFSafariViewControllerDelegate {
    
    var activity = UIActivityIndicatorView()
    var oldOffset : NSValue? // use nil as indicator
    var oldHTMLString : String?
    var oldBase : NSURL?
    
    var fontsize = 18
    var cssrule : String {
        var s = "var s = document.createElement('style');\n"
        s += "s.textContent = '"
        s += "body { font-size: \(self.fontsize)px; }"
        s += "';\n"
        s += "document.documentElement.appendChild(s);\n"
        return s
    }
    weak var wv : WKWebView!
    
    required override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "wvc"
        self.restorationClass = self.dynamicType
        self.edgesForExtendedLayout = .None // get accurate offset restoration
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    
    class func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject], coder: NSCoder) -> UIViewController? {
        let id = identifierComponents.last as! String
        if id == "wvc" {
            print("recreating wvc view controller")
            return self.init(nibName:nil, bundle:nil)
        }
        return nil
    }
    
    // we must save and restore offset ourselves
    // note that I don't touch the web view at this point: just an ivar
    // we don't have any web content yet!
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        print("decode")
        super.decodeRestorableStateWithCoder(coder)
        if let oldOffset = coder.decodeObjectForKey("oldOffset") as? NSValue {
            print("retrieved old offset as \(oldOffset)")
            self.oldOffset = oldOffset // for local example
        }
        if let fontsize = coder.decodeObjectForKey("fontsize") as? Int {
            self.fontsize = fontsize
        }
        if let oldHTMLString = coder.decodeObjectForKey("oldHTMLString") as? String {
            self.oldHTMLString = oldHTMLString
        }
        if let oldBase = coder.decodeObjectForKey("oldBase") as? NSURL {
            self.oldBase = oldBase
        }
    }
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        print("encode")
        super.encodeRestorableStateWithCoder(coder)
        // we have to manage offset ourselves
        let off = self.wv.scrollView.contentOffset
        print("saving offset \(off)")
        coder.encodeObject(NSValue(CGPoint:off), forKey:"oldOffset")
        coder.encodeObject(self.fontsize, forKey:"fontsize")
        coder.encodeObject(self.oldHTMLString, forKey:"oldHTMLString")
        coder.encodeObject(self.oldBase, forKey:"oldBase")
    }
    
    override func applicationFinishedRestoringState() {
        print("finished restoring state") // still too soon to fix offset, not loaded yet
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // a configuration consists of preferences (e.g. JavaScript behavior),
        // and a user content controller that allows JavaScript messages to be sent/received
        // it is copied, so if we supply one we can't change it later
        // alternatively, to use a default configuration, use frame alone
        
        // here, frame unimportant, we will be sized automatically
        let wv = WKWebView(frame: CGRectZero)
        self.wv = wv
        
        // inject a CSS rule (example taken from WWDC 2014 video)
        // (instead of body style containing font-size:<fontsize>px; in template)

        let s = self.cssrule
        let script = WKUserScript(source: s, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        self.wv.configuration.userContentController.addUserScript(script)

        // prepare to receive messages under the "playbutton" name
        // unfortunately there's a bug: the script message handler cannot be self,
        // or we will leak
        
        var leak : Bool { return false }
        switch leak {
        case true:
            self.wv.configuration.userContentController.addScriptMessageHandler(
                self, name: "playbutton")
        case false:
            self.wv.configuration.userContentController.addScriptMessageHandler(
                MyMessageHandler(delegate:self), name: "playbutton")
        }
        
        
        wv.restorationIdentifier = "wv"
        wv.scrollView.backgroundColor = UIColor.blackColor() // web view alone, ineffective
        self.view.addSubview(wv)
        wv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[wv]|", options: [], metrics: nil, views: ["wv":wv]),
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[wv]|", options: [], metrics: nil, views: ["wv":wv])
            ].flatten().map{$0})
        wv.navigationDelegate = self
        
        // sorry, missing this feature
//        wv.paginationMode = .LeftToRight
//        wv.scrollView.pagingEnabled = true
        
        // prove we can attach gesture recognizer to web view's scroll view
        let swipe = UISwipeGestureRecognizer(target:self, action:"swipe:")
        swipe.direction = .Left
        wv.scrollView.addGestureRecognizer(swipe)
        wv.allowsBackForwardNavigationGestures = false
        
        // prepare nice activity indicator to cover loading
        let act = UIActivityIndicatorView(activityIndicatorStyle:.WhiteLarge)
        act.backgroundColor = UIColor(white:0.1, alpha:0.5)
        self.activity = act
        wv.addSubview(act)
        act.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            act.centerXAnchor.constraintEqualToAnchor(wv.centerXAnchor),
            act.centerYAnchor.constraintEqualToAnchor(wv.centerYAnchor)
            ])
        // webkit uses KVO
        wv.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        // cool feature, show title
        wv.addObserver(self, forKeyPath: "title", options: .New, context: nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        guard let wv = object as? WKWebView else {return}
        guard let keyPath = keyPath else {return}
        guard let change = change else {return}
        switch keyPath {
        case "loading": // new:1 or 0
            if let val = change[NSKeyValueChangeNewKey] as? Bool {
                if val {
                    self.activity.startAnimating()
                } else {
                    self.activity.stopAnimating()
                    print("stopping animating")
                    // for our *local* example, restoring offset is up to us
                    if self.oldOffset != nil { // local example
                        if wv.estimatedProgress == 1 {
                            delay(0.1) { // had to introduce delay; there's a flash but there's nothing I can do
                                print("finished loading! restoring offset")
                                wv.scrollView.contentOffset = self.oldOffset!.CGPointValue()
                                self.oldOffset = nil
                            }
                        }
                    }
                }
            }
        case "title": // not actually showing it in this example
            if let val = change[NSKeyValueChangeNewKey] as? String {
                print(val)
            }
        default:break
        }
    }
    
    func swipe(g:UIGestureRecognizer) {
        print("swipe") // okay, you proved it!
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear, req: \(self.wv.URL)")

        if !self.isMovingToParentViewController() {
            return // so we don't do this again when a presented view controller is dismissed
        }
        
        var which : Int { return 1 }
        switch which {
        case 1:
            let b = UIBarButtonItem(title: "Size", style: .Plain, target: self, action: "doDecreaseSize:")
            self.navigationItem.rightBarButtonItems = [b]
            
            if let oldHTMLString = self.oldHTMLString, let oldBase = self.oldBase {
                print("restoring html")
                self.wv.loadHTMLString(oldHTMLString, baseURL:oldBase)
                return
            }
            
            let bodypath = NSBundle.mainBundle().pathForResource("htmlbody", ofType:"txt")!
            let ss = try! String(contentsOfFile:bodypath, encoding:NSUTF8StringEncoding)
            
            let templatepath = NSBundle.mainBundle().pathForResource("htmlTemplate", ofType:"txt")!
            let base = NSURL.fileURLWithPath(templatepath)
            var s = try! String(contentsOfFile:templatepath, encoding:NSUTF8StringEncoding)
            
            s = s.stringByReplacingOccurrencesOfString("<maximagewidth>", withString:"80%")
            s = s.stringByReplacingOccurrencesOfString("<margin>", withString:"10")
            s = s.stringByReplacingOccurrencesOfString("<guid>", withString:"http://tidbits.com/article/12228")
            s = s.stringByReplacingOccurrencesOfString("<ourtitle>", withString:"Lion Details Revealed with Shipping Date and Price")
            // note way to set up messaging from web page's javascript to us
            s = s.stringByReplacingOccurrencesOfString("<playbutton>", withString:"<img src=\"listen.png\" onclick=\"window.webkit.messageHandlers.playbutton.postMessage('play')\">")
            s = s.stringByReplacingOccurrencesOfString("<author>", withString:"TidBITS Staff")
            s = s.stringByReplacingOccurrencesOfString("<date>", withString:"Mon, 06 Jun 2011 13:00:39 PDT")
            s = s.stringByReplacingOccurrencesOfString("<content>", withString:ss)
            
            self.wv.loadHTMLString(s, baseURL:base) // works in iOS 9! local and remote images are loading
            self.oldHTMLString = s
            self.oldBase = base
        case 2:
            let path = NSBundle.mainBundle().pathForResource("release", ofType:"pdf")!
            let url = NSURL.fileURLWithPath(path)
            self.wv.loadFileURL(url, allowingReadAccessToURL: url)
        case 3:
            let path = NSBundle.mainBundle().pathForResource("testing", ofType:"pdf")!
            let url = NSURL.fileURLWithPath(path)
            self.wv.loadFileURL(url, allowingReadAccessToURL: url)
        case 4:
            let path = NSBundle.mainBundle().pathForResource("test", ofType:"rtf")!
            let url = NSURL.fileURLWithPath(path)
            self.wv.loadFileURL(url, allowingReadAccessToURL: url)
        case 5:
            let path = NSBundle.mainBundle().pathForResource("test", ofType:"doc")!
            let url = NSURL.fileURLWithPath(path)
            self.wv.loadFileURL(url, allowingReadAccessToURL: url)
        case 6:
            let path = NSBundle.mainBundle().pathForResource("test", ofType:"docx")!
            let url = NSURL.fileURLWithPath(path)
            self.wv.loadFileURL(url, allowingReadAccessToURL: url)
        case 7:
            let path = NSBundle.mainBundle().pathForResource("test", ofType:"pages")! // blank on device
            let url = NSURL.fileURLWithPath(path)
            self.wv.loadFileURL(url, allowingReadAccessToURL: url)
        case 8:
            let path = NSBundle.mainBundle().pathForResource("test.pages", ofType:"zip")! // slow, but it does work!
            let url = NSURL.fileURLWithPath(path)
            self.wv.loadFileURL(url, allowingReadAccessToURL: url)
        case 9:
            let path = NSBundle.mainBundle().pathForResource("test", ofType:"rtfd")! // blank on device
            let url = NSURL.fileURLWithPath(path)
            self.wv.loadFileURL(url, allowingReadAccessToURL: url)
        case 10:
            let path = NSBundle.mainBundle().pathForResource("test.rtfd", ofType:"zip")! // displays "Unable to Read Document."
            let url = NSURL.fileURLWithPath(path)
            self.wv.loadFileURL(url, allowingReadAccessToURL: url)
        case 11:
            let path = NSBundle.mainBundle().pathForResource("htmlbody", ofType:"txt")!
            let url = NSURL.fileURLWithPath(path)
            self.wv.loadFileURL(url, allowingReadAccessToURL: url)
        case 12:
            let url = NSURL(string: "http://www.apeth.com/rez/release.pdf")!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 13:
            let url = NSURL(string: "http://www.apeth.com/rez/testing.pdf")!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 14:
            let url = NSURL(string: "http://www.apeth.com/rez/test.rtf")!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 15:
            let url = NSURL(string: "http://www.apeth.com/rez/test.doc")!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 16:
            let url = NSURL(string: "http://www.apeth.com/rez/test.docx")!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 17:
            let url = NSURL(string: "http://www.apeth.com/rez/test.pages.zip")!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 18:
            let url = NSURL(string: "http://www.apeth.com/rez/test.rtfd.zip")! // nope :(
            self.wv.loadRequest(NSURLRequest(URL: url))

        default: break
        }
        

    }
    
    // showing how to inject JavaScript dynamically (as opposed to at page-load time)
    
    func doDecreaseSize (sender:AnyObject) {
        self.fontsize -= 1
        if self.fontsize < 10 {
            self.fontsize = 20
        }
        let s = self.cssrule
        self.wv.evaluateJavaScript(s, completionHandler: nil)
    }
    
    deinit {
        print("dealloc")
        // using KVO, always tear down, take no chances
        self.wv.removeObserver(self, forKeyPath: "loading")
        self.wv.removeObserver(self, forKeyPath: "title")
        // with webkit, probably no need for this, but no harm done
        self.wv.stopLoading()
        // break all retains
        self.wv.configuration.userContentController.removeAllUserScripts()
        self.wv.configuration.userContentController.removeScriptMessageHandlerForName("playbutton")
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
        if navigationAction.navigationType == .LinkActivated {
            if let url = navigationAction.request.URL {
                print("user would like to navigate to \(url)")
                // this is how you would open in Mobile Safari
                // UIApplication.sharedApplication().openURL(url)
                // this is how to use the new Safari view controller
                let svc = SFSafariViewController(URL: url)
                // svc.delegate = self
                self.presentViewController(svc, animated: true, completion: nil)
                decisionHandler(.Cancel)
                return
            }
        }
        // must always call _something_
        decisionHandler(.Allow)
    }
    
    func webViewWebContentProcessDidTerminate(webView: WKWebView) { // new in iOS 9
        print("process did terminate") // but I do not know under what circumstances this will actually be called
    }

    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("loaded svc")
    }

    
    func userContentController(userContentController: WKUserContentController,
        didReceiveScriptMessage message: WKScriptMessage) {
            if message.name == "playbutton" {
                if let body = message.body as? String {
                    if body == "play" {
                        print("user would like to hear the podcast")
                    }
                }
            }
    }


}

