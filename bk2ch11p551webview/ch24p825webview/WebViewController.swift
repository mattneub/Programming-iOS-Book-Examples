
import UIKit

class WebViewController: UIViewController, UIWebViewDelegate, UIViewControllerRestoration {
    
    var activity = UIActivityIndicatorView()
    var oldOffset : NSValue? // use nil as indicator
    
    var canNavigate = false // distinguish the two examples, local and remote content
    
    var wv : UIWebView {
    return self.view as UIWebView
    }
    
    required init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "wvc"
        self.restorationClass = self.dynamicType
        let b = UIBarButtonItem(title:"Back", style:.Bordered, target:self, action:"goBack:")
        self.navigationItem.rightBarButtonItem = b
        self.edgesForExtendedLayout = .None // get accurate offset restoration
    }
    
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
    
    deinit {
        println("dealloc")
        self.wv.stopLoading()
        self.wv.delegate = nil
    }
    
    override func loadView() {
        let wv = UIWebView()
        wv.restorationIdentifier = "wv"
        wv.backgroundColor = UIColor.blackColor()
        self.view = wv
        wv.delegate = self
        
        // new iOS 7 feature! uncomment to try it
//        wv.paginationMode = .LeftToRight
//        wv.scrollView.pagingEnabled = true
        
        // prove that we can attach gesture recognizer to web view's scroll view
        let swipe = UISwipeGestureRecognizer(target:self, action:"swipe:")
        swipe.direction = .Left
        wv.scrollView.addGestureRecognizer(swipe)
        
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
    }
    
    func swipe(g:UIGestureRecognizer) {
        println("swipe") // okay, you proved it
    }
    
    let LOADREQ = 1 // 0, or try 1 for a different application...
    // one that loads an actual request and lets you experiment with state saving and restoration
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("view did appear, req: \(self.wv.request)")
        
        if LOADREQ == 1 {
            self.canNavigate = true
            if self.wv.request { // let applicationFinished handle reloading
                return
            }
            let url = NSURL(string: "http://www.apeth.com/RubyFrontierDocs/default.html")
            self.wv.loadRequest(NSURLRequest(URL:url))
            return
        }
        
        let path = NSBundle.mainBundle().pathForResource("htmlbody", ofType:"txt")
        let base = NSURL.fileURLWithPath(path)
        let ss = NSString(contentsOfFile:path, encoding:NSUTF8StringEncoding, error:nil)
        
        let path2 = NSBundle.mainBundle().pathForResource("htmlTemplate", ofType:"txt")
        var s = NSString(contentsOfFile:path, encoding:NSUTF8StringEncoding, error:nil)

        s = s.stringByReplacingOccurrencesOfString("<maximagewidth>", withString:"80%")
        s = s.stringByReplacingOccurrencesOfString("<fontsize>", withString:"18")
        s = s.stringByReplacingOccurrencesOfString("<margin>", withString:"10")
        s = s.stringByReplacingOccurrencesOfString("<guid>", withString:"http://tidbits.com/article/12228")
        s = s.stringByReplacingOccurrencesOfString("<ourtitle>", withString:"Lion Details Revealed with Shipping Date and Price")
        s = s.stringByReplacingOccurrencesOfString("<playbutton>", withString:"<img src=\"listen.png\" onclick=\"document.location='play:me'\">")
        s = s.stringByReplacingOccurrencesOfString("<author>", withString:"TidBITS Staff")
        s = s.stringByReplacingOccurrencesOfString("<date>", withString:"Mon, 06 Jun 2011 13:00:39 PDT")
        s = s.stringByReplacingOccurrencesOfString("<content>", withString:ss)
        
        self.wv.loadHTMLString(s, baseURL:base)

    }
    
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
    
    func webView(webView: UIWebView!, shouldStartLoadWithRequest r: NSURLRequest!, navigationType nt: UIWebViewNavigationType) -> Bool {
        if r.URL.scheme == "play" {
            println("user would like to hear the podcast")
            return false
        }
        if nt == .LinkClicked { // disable link-clicking
            if self.canNavigate {
                return true
            }
            println("user would like to navigation to \(r.URL)")
            // this is how you would open in Mobile Safari
            // UIApplication.sharedApplication().openURL(r.URL)
            return false
        }
        return true
    }
    
    func goBack(sender:AnyObject) {
        if self.wv.canGoBack {
            self.wv.goBack()
        }
    }
}
