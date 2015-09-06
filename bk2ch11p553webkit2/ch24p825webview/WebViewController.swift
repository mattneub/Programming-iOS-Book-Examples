
import UIKit
import WebKit

class WebViewController: UIViewController, UIViewControllerRestoration {
    var activity = UIActivityIndicatorView()
    weak var wv : WKWebView!
    var decoded = false
    
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
        return self.init(nibName:nil, bundle:nil)
    }
    
    // unfortunately I see no evidence that the web view is assisting us at all!
    // the view is not coming back with its URL restored etc, as a UIWebView does

    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        print("decode")
        self.decoded = true
        super.decodeRestorableStateWithCoder(coder)
    }
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        print("encode")
        super.encodeRestorableStateWithCoder(coder)
    }


    override func applicationFinishedRestoringState() {
        print("finished restoring state", self.wv.URL)
    }

    override func loadView() {
        print("loadView")
        super.loadView()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
                
        let wv = WKWebView(frame: CGRectZero)
        wv.restorationIdentifier = "wv"
        self.view.restorationIdentifier = "wvcontainer" // shouldn't be necessary...
        wv.scrollView.backgroundColor = UIColor.blackColor() // web view alone, ineffective
        self.view.addSubview(wv)
        wv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[wv]|", options: [], metrics: nil, views: ["wv":wv]),
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[wv]|", options: [], metrics: nil, views: ["wv":wv])
            ].flatten().map{$0})
        self.wv = wv
                
        // take advantage of built-in "back" and "forward" swipe gestures
        wv.allowsBackForwardNavigationGestures = true
        
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
        
        wv.navigationDelegate = self
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
            guard let _ = object as? WKWebView else {return}
            guard let keyPath = keyPath else {return}
            guard let change = change else {return}
            switch keyPath {
            case "loading": // new:1 or 0
                if let val = change[NSKeyValueChangeNewKey] as? Bool {
                    if val {
                        self.activity.startAnimating()
                    } else {
                        self.activity.stopAnimating()
                    }
                }
            case "title": // not actually showing it in this example
                if let val = change[NSKeyValueChangeNewKey] as? String {
                    self.navigationItem.title = val
                }
            default:break
            }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear, req: \(self.wv.URL)") // no evidence that restoration is being done for us
        
        let b = UIBarButtonItem(title:"Back", style:.Plain, target:self, action:"goBack:")
        self.navigationItem.rightBarButtonItems = [b]
        
        if self.decoded {
            // return // forget it, just trying to see if I was in restoration's way, but I'm not
        }
        
        let url = NSURL(string: "http://www.apeth.com/RubyFrontierDocs/default.html")!
        self.wv.loadRequest(NSURLRequest(URL:url))
    }
    

    deinit {
        print("dealloc")
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
        print("did commit \(navigation)")
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print("did fail")
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print("did fail provisional")
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("did finish")
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("did start")
    }
}

