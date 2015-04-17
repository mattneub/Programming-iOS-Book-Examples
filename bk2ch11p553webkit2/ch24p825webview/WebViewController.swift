
import UIKit
import WebKit

class WebViewController: UIViewController, UIViewControllerRestoration {
    var activity = UIActivityIndicatorView()
    weak var wv : WKWebView!
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
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
    
    // unfortunately I see no evidence that the web view is assisting us at all!
    // the view is not coming back with its URL restored etc, as a UIWebView does

    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        println("decode")
        super.decodeRestorableStateWithCoder(coder)
//        let oldOffset = coder.decodeObjectForKey("oldOffset") as? NSValue
//        println("retrieved old offset as \(oldOffset)")
//        self.oldOffset = oldOffset // for local example
    }
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        println("encode")
        super.encodeRestorableStateWithCoder(coder)
//        if !self.canNavigate { // local example; we have to manage offset ourselves
//            let off = self.wv.scrollView.contentOffset
//            println("saving offset \(off)")
//            coder.encodeObject(NSValue(CGPoint:off), forKey:"oldOffset")
//        }
    }


    override func applicationFinishedRestoringState() {
        println("finished restoring state")
//        if self.wv.request {
//            // remote example
//            self.wv.reload()
//        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(self.wv)
        
        let wv = WKWebView(frame: CGRectZero)
        wv.restorationIdentifier = "wv"
        self.view.restorationIdentifier = "wvcontainer" // shouldn't be necessary...
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
                
        // in this example, navigation is possible
        // take advantage of built-in "back" gesture?
        wv.allowsBackForwardNavigationGestures = true
        // but what is the gesture? I can't make anything happen
        
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
        
        wv.navigationDelegate = self
        
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
                        }
                    }
                }
            case "title": // but not for our static local example, please
                if let val:AnyObject = change[NSKeyValueChangeNewKey] {
                    if let val = val as? String {
                        self.navigationItem.title = val
                    }
                }
            default:break
            }
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("view did appear, req: \(self.wv.URL)") // no evidence that restoration is being done for us
        
        let b = UIBarButtonItem(title:"Back", style:.Plain, target:self, action:"goBack:")
        self.navigationItem.rightBarButtonItems = [b]
//            if self.wv.URL {  let applicationFinished handle reloading
//                return
//            }
        let url = NSURL(string: "http://www.apeth.com/RubyFrontierDocs/default.html")!
        self.wv.loadRequest(NSURLRequest(URL:url))
    }
    

    deinit {
        println("dealloc")
        // using KVO, always tear down, take no chances
        self.wv.removeObserver(self, forKeyPath: "loading")
        self.wv.removeObserver(self, forKeyPath: "title")
        // with webkit, probably no need for this, but no harm done
        self.wv.stopLoading()
    }
        
    func goBack(sender:AnyObject) {
        self.wv.goBack()
    }
    

}

extension WebViewController : WKNavigationDelegate {
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation) {
        println("did commit \(navigation)")
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        println("did fail")
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        println("did fail provisional")
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        println("did finish")
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        println("did start")
    }
}

