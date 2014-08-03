
import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var activity = UIActivityIndicatorView()
    var oldOffset : NSValue? // use nil as indicator
    
    var fontsize = 18
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
    var canNavigate = false // distinguishes the two examples, local and remote content
    weak var wv : WKWebView!
    
    required init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.restorationIdentifier = "wvc"
//        self.restorationClass = self.dynamicType
//        let b = UIBarButtonItem(title:"Back", style:.Bordered, target:self, action:"goBack:")
//        self.navigationItem.rightBarButtonItem = b
        self.edgesForExtendedLayout = .None // get accurate offset restoration
    }
    
    /*
    
    class func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject]!, coder: NSCoder!) -> UIViewController! {
        return self(nibName:nil, bundle:nil)
    }
    
    // for the local page example, we must save and restore offset ourselves
    // note that I don't touch the web view at this point: just an ivar
    // we don't have any web content yet!

    override func decodeRestorableStateWithCoder(coder: NSCoder!) {
        println("decode")
        super.decodeRestorableStateWithCoder(coder)
        self.oldOffset = coder.decodeObjectForKey("oldOffset") as? NSValue // for local example
    }
    
    override func encodeRestorableStateWithCoder(coder: NSCoder!) {
        println("encode")
        super.encodeRestorableStateWithCoder(coder)
        if !self.canNavigate { // local example; we have to manage offset ourselves
            println("saving offset")
            let off = self.wv.scrollView.contentOffset
            coder.encodeObject(NSValue(CGPoint:off), forKey:"oldOffset")
        }
    }
    
    override func applicationFinishedRestoringState() {
        if self.wv.request {
            // remote example
            self.wv.reload()
        }
    }
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // a configuration consists of preferences (e.g. JavaScript behavior),
        // and a user content controller that allows JavaScript messages to be sent/received
        // it is copied, so if we supply one we can't change it later
        // alternatively, to use a default configuration, use frame alone
        
        let ucc = WKUserContentController()
        
        // prepare to receive messages under the "playbutton" name
        // unfortunately there's a bug: the script message handler cannot be self,
        // or we will leak
        ucc.addScriptMessageHandler(self, name: "playbutton")
        
        // inject a CSS rule (example taken from WWDC 2014 video)
        // (instead of body style containing font-size:<fontsize>px; in template)
        let s = self.cssrule
        let script = WKUserScript(source: s, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        ucc.addUserScript(script)
        
        let config = WKWebViewConfiguration()
        config.userContentController = ucc
        
        // here, frame unimportant, we will be sized automatically
        let wv = WKWebView(frame: CGRectZero, configuration: config)
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
        self.wv = wv
        
        wv.navigationDelegate = self
        
        // sorry, missing this feature
//        wv.paginationMode = .LeftToRight
//        wv.scrollView.pagingEnabled = true
        
        // prove that we can attach gesture recognizer to web view's scroll view
//        let swipe = UISwipeGestureRecognizer(target:self, action:"swipe:")
//        swipe.direction = .Left
//        wv.scrollView.addGestureRecognizer(swipe)
        
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
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafePointer<()>) {
        if let wv = object as? WKWebView {
            switch keyPath! {
            case "loading": // new:1 or 0
                if let val:AnyObject = change[NSKeyValueChangeNewKey] {
                    if let val = val as? Bool {
                        if val {
                            self.activity.startAnimating()
                        } else {
                            self.activity.stopAnimating()
                        }
                    }
                }
            case "title": // but not for our static local example, please
                if let val:AnyObject = change[NSKeyValueChangeNewKey] {
                    if let val = val as? String {
                        if self.canNavigate {
                            self.navigationItem.title = val
                        }
                    }
                }
            default:break
            }
        }
    }
    
    
//    func swipe(g:UIGestureRecognizer) {
//        println("swipe") // okay, you proved it
//    }
//    
//    let LOADREQ = 1 // 0, or try 1 for a different application...
//    // one that loads an actual request and lets you experiment with state saving and restoration
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //println("view did appear, req: \(self.wv.request)")
        
//        if LOADREQ == 1 {
//            self.canNavigate = true
//            if self.wv.request { // let applicationFinished handle reloading
//                return
//            }
//            let url = NSURL(string: "http://www.apeth.com/RubyFrontierDocs/default.html")
//            self.wv.loadRequest(NSURLRequest(URL:url))
//            return
//        }
        
        let b = UIBarButtonItem(title: "Size", style: .Plain, target: self, action: "doDecreaseSize:")
        self.navigationItem.rightBarButtonItems = [b]
        
        let path = NSBundle.mainBundle().pathForResource("htmlbody", ofType:"txt")
        let base = NSURL.fileURLWithPath(path)
        let ss = NSString(contentsOfFile:path, encoding:NSUTF8StringEncoding, error:nil)
        
        let path2 = NSBundle.mainBundle().pathForResource("htmlTemplate", ofType:"txt")
        var s = NSString(contentsOfFile:path2, encoding:NSUTF8StringEncoding, error:nil)

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
        self.wv.loadHTMLString(s, baseURL:base)

    }
    
    // showing how to inject JavaScript dynamically (as opposed to at page-load time)
    
    func doDecreaseSize (sender:AnyObject) {
        self.fontsize -= 1
        let s = self.cssrule
        self.wv.evaluateJavaScript(s, completionHandler: nil)
    }
    
    
    // work around memory leak (retain cycle)
    override func viewWillDisappear(animated: Bool) {
        if self.isMovingFromParentViewController() {
            self.wv.configuration.userContentController.removeScriptMessageHandlerForName("playbutton")
        }
    }
    
    deinit {
        println("dealloc")
        // using KVO, always tear down, take no chances
        self.wv.removeObserver(self, forKeyPath: "loading")
        self.wv.removeObserver(self, forKeyPath: "title")
        // with webkit, probably no need for this, but no harm done
        self.wv.stopLoading()
    }

    /*
    
    func webViewDidStartLoad(wv: UIWebView!) {
        self.activity.startAnimating()
    }
    
    func webViewDidFinishLoad(wv: UIWebView!) {
        self.activity.stopAnimating()
        // for our *local* example, restoring offset is up to us
        if self.oldOffset != nil && !self.canNavigate { // local example
            println("restoring offset")
            wv.scrollView.contentOffset = self.oldOffset!.CGPointValue()
        }
        self.oldOffset = nil
    }
    
    func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
        self.activity.stopAnimating()
    }
    
    */
    
    func webView(webView: WKWebView!, decidePolicyForNavigationAction navigationAction: WKNavigationAction!, decisionHandler: ((WKNavigationActionPolicy) -> Void)!) {
        if navigationAction.navigationType == .LinkActivated {
            if self.canNavigate {
                decisionHandler(.Allow)
            } else {
                let url = navigationAction.request.URL
                println("user would like to navigate to \(url)")
                // this is how you would open in Mobile Safari
                // UIApplication.sharedApplication().openURL(url)
                decisionHandler(.Cancel)
            }
        }
        // must always call _something_
        decisionHandler(.Allow)
    }
    
        
    func goBack(sender:AnyObject) {
//        if self.wv.canGoBack {
//            self.wv.goBack()
//        }
    }
    
    func userContentController(userContentController: WKUserContentController!,
        didReceiveScriptMessage message: WKScriptMessage!) {
            if message.name == "playbutton" {
                if let body = message.body as? String {
                    if body == "play" {
                        println("user would like to hear the podcast")
                    }
                }
            }
    }

}

