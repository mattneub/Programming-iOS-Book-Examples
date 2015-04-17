
import UIKit
import WebKit

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
        println("message handler dealloc")
    }
}

class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, UIViewControllerRestoration {
    
    var activity = UIActivityIndicatorView()
    var oldOffset : NSValue? // use nil as indicator
    
    var fontsize = 18 // should save and restore this but it's only an example
    var cssrule : String {
    get {
        var s = "var s = document.createElement('style');\n"
        s += "s.textContent = '"
        s += "body { font-size: \(self.fontsize)px; }"
        s += "';\n"
        s += "document.documentElement.appendChild(s);\n"
        return s
    }
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
        return self(nibName:nil, bundle:nil)
    }
    
    // we must save and restore offset ourselves
    // note that I don't touch the web view at this point: just an ivar
    // we don't have any web content yet!

    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        println("decode")
        super.decodeRestorableStateWithCoder(coder)
        let oldOffset = coder.decodeObjectForKey("oldOffset") as? NSValue
        println("retrieved old offset as \(oldOffset)")
        self.oldOffset = oldOffset // for local example
    }
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        println("encode")
        super.encodeRestorableStateWithCoder(coder)
        // we have to manage offset ourselves
        let off = self.wv.scrollView.contentOffset
        println("saving offset \(off)")
        coder.encodeObject(NSValue(CGPoint:off), forKey:"oldOffset")
    }
    
    override func applicationFinishedRestoringState() {
        println("finished restoring state") // still too soon to fix offset, not loaded yet
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
        
        self.wv.configuration.userContentController.addScriptMessageHandler(
            MyMessageHandler(delegate:self), name: "playbutton")
        
        wv.restorationIdentifier = "wv"
        wv.scrollView.backgroundColor = UIColor.blackColor() // web view alone, ineffective
        self.view.addSubview(wv)
        wv.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[wv]|", options: nil, metrics: nil, views: ["wv":wv])
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[wv]|", options: nil, metrics: nil, views: ["wv":wv])
        )
        
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
        act.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraint(
            NSLayoutConstraint(item: act, attribute: .CenterX, relatedBy: .Equal, toItem: wv, attribute: .CenterX, multiplier: 1, constant: 0)
        )
        self.view.addConstraint(
            NSLayoutConstraint(item: act, attribute: .CenterY, relatedBy: .Equal, toItem: wv, attribute: .CenterY, multiplier: 1, constant: 0)
        )
        
        // webkit uses KVO
        wv.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        // cool feature, show title
        wv.addObserver(self, forKeyPath: "title", options: .New, context: nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        if let wv = object as? WKWebView {
            switch keyPath {
            case "loading": // new:1 or 0
                if let val:AnyObject = change[NSKeyValueChangeNewKey] {
                    if let val = val as? Bool {
                        if val {
                            self.activity.startAnimating()
                        } else {
                            self.activity.stopAnimating()
                            println("stopping animating")
                            // for our *local* example, restoring offset is up to us
                            if self.oldOffset != nil { // local example
                                if wv.estimatedProgress == 1 {
                                    println("finished loading! restoring offset")
                                    wv.scrollView.contentOffset = self.oldOffset!.CGPointValue()
                                    self.oldOffset = nil
                                }
                            }
                        }
                    }
                }
            case "title": // not actually showing it in this example
                if let val:AnyObject = change[NSKeyValueChangeNewKey] {
                    if let val = val as? String {
                        println(val)
                    }
                }
            default:break
            }
        }
    }
    
    func swipe(g:UIGestureRecognizer) {
        println("swipe") // okay, you proved it!
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("view did appear, req: \(self.wv.URL)")
        
        let which = 1
        switch which {
        case 1:
            let b = UIBarButtonItem(title: "Size", style: .Plain, target: self, action: "doDecreaseSize:")
            self.navigationItem.rightBarButtonItems = [b]
            
            let bodypath = NSBundle.mainBundle().pathForResource("htmlbody", ofType:"txt")!
            let ss = String(contentsOfFile:bodypath, encoding:NSUTF8StringEncoding, error:nil)!
            
            let templatepath = NSBundle.mainBundle().pathForResource("htmlTemplate", ofType:"txt")!
            let base = NSURL.fileURLWithPath(templatepath)!
            var s = String(contentsOfFile:templatepath, encoding:NSUTF8StringEncoding, error:nil)!
            
            s = s.stringByReplacingOccurrencesOfString("<maximagewidth>", withString:"80%")
            s = s.stringByReplacingOccurrencesOfString("<margin>", withString:"10")
            s = s.stringByReplacingOccurrencesOfString("<guid>", withString:"http://tidbits.com/article/12228")
            s = s.stringByReplacingOccurrencesOfString("<ourtitle>", withString:"Lion Details Revealed with Shipping Date and Price")
            // note way to set up messaging from web page's javascript to us
            s = s.stringByReplacingOccurrencesOfString("<playbutton>", withString:"<img src=\"listen.png\" onclick=\"window.webkit.messageHandlers.playbutton.postMessage('play')\">")
            s = s.stringByReplacingOccurrencesOfString("<author>", withString:"TidBITS Staff")
            s = s.stringByReplacingOccurrencesOfString("<date>", withString:"Mon, 06 Jun 2011 13:00:39 PDT")
            s = s.stringByReplacingOccurrencesOfString("<content>", withString:ss)
            
            // missing from docs, but in header file
            self.wv.loadHTMLString(s, baseURL:base) // fails on device, because we can't load the local image
            // ===========================
            // so, WKWebView can't load _any_ files using a local file URL
            // but the other types work fine except for rtf / rtfd which is a known issue (see release notes)
            // here are some tests...
        case 2:
            let path = NSBundle.mainBundle().pathForResource("release", ofType:"pdf")! // works in simulator, blank on the device, "Could not create a sandbox extension for '/'"
            let url = NSURL.fileURLWithPath(path)!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 3:
            let path = NSBundle.mainBundle().pathForResource("testing", ofType:"pdf")! // works in simulator, blank on the device, "Could not create a sandbox extension for '/'"
            let url = NSURL.fileURLWithPath(path)!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 4:
            let path = NSBundle.mainBundle().pathForResource("test", ofType:"rtf")! // works in simulator, blank on the device, "Could not create a sandbox extension for '/'"
            let url = NSURL.fileURLWithPath(path)!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 5:
            let path = NSBundle.mainBundle().pathForResource("test", ofType:"doc")! // works in simulator, blank on the device, "Could not create a sandbox extension for '/'"
            let url = NSURL.fileURLWithPath(path)!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 6:
            let path = NSBundle.mainBundle().pathForResource("test", ofType:"docx")!  // works in simulator, blank on the device, "Could not create a sandbox extension for '/'"
            let url = NSURL.fileURLWithPath(path)!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 7:
            let path = NSBundle.mainBundle().pathForResource("test", ofType:"pages")! // blank in simulator, blank on the device, "Could not create a sandbox extension for '/'"
            let url = NSURL.fileURLWithPath(path)!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 8:
            let path = NSBundle.mainBundle().pathForResource("test.pages", ofType:"zip")! // works in simulator, blank on the device, "Could not create a sandbox extension for '/'"
            let url = NSURL.fileURLWithPath(path)!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 9:
            let path = NSBundle.mainBundle().pathForResource("test", ofType:"rtfd")! // blank in simulator, blank on the device, "Could not create a sandbox extension for '/'"
            let url = NSURL.fileURLWithPath(path)!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 10:
            let path = NSBundle.mainBundle().pathForResource("test.rtfd", ofType:"zip")! // blank in simulator, blank on the device, "Could not create a sandbox extension for '/'"
            let url = NSURL.fileURLWithPath(path)!
            println(path)
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 11:
            let path = NSBundle.mainBundle().pathForResource("htmlbody", ofType:"txt")!
            let url = NSURL.fileURLWithPath(path)!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 12:
            let url = NSURL(string: "http://www.apeth.com/rez/release.pdf")! // yep!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 13:
            let url = NSURL(string: "http://www.apeth.com/rez/testing.pdf")! // yep!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 14:
            let url = NSURL(string: "http://www.apeth.com/rez/test.rtf")! // nope... yep! fixed in 8.1
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 15:
            let url = NSURL(string: "http://www.apeth.com/rez/test.doc")! // yep!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 16:
            let url = NSURL(string: "http://www.apeth.com/rez/test.docx")! // yep!
            self.wv.loadRequest(NSURLRequest(URL: url))
        case 18:
            let url = NSURL(string: "http://www.apeth.com/rez/test.pages.zip")! // yep!
            self.wv.loadRequest(NSURLRequest(URL: url))

        case 20:
            let url = NSURL(string: "http://www.apeth.com/rez/test.rtfd.zip")! // nope :(
            self.wv.loadRequest(NSURLRequest(URL: url))

        default: break
        }
        

    }
    
    // showing how to inject JavaScript dynamically (as opposed to at page-load time)
    
    func doDecreaseSize (sender:AnyObject) {
        self.fontsize -= 1
        let s = self.cssrule
        self.wv.evaluateJavaScript(s, completionHandler: nil)
    }
    
    deinit {
        println("dealloc")
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
            let url = navigationAction.request.URL
            println("user would like to navigate to \(url)")
            // this is how you would open in Mobile Safari
            // UIApplication.sharedApplication().openURL(url)
            decisionHandler(.Cancel)
            return
        }
        // must always call _something_
        decisionHandler(.Allow)
    }
    
    func userContentController(userContentController: WKUserContentController,
        didReceiveScriptMessage message: WKScriptMessage) {
            if message.name == "playbutton" {
                if let body = message.body as? String {
                    if body == "play" {
                        println("user would like to hear the podcast")
                    }
                }
            }
    }


}

