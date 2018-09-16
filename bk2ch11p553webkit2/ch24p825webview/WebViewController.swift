
import UIKit
import WebKit

class WebViewController: UIViewController, UIViewControllerRestoration {
    var activity = UIActivityIndicatorView()
    weak var wv : WKWebView!
    var decoded = false
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "wvc"
        self.restorationClass = type(of:self)
        self.edgesForExtendedLayout = [] // none, get accurate offset restoration
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    class func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        return self.init(nibName:nil, bundle:nil)
    }
    
    // unfortunately I see no evidence that the web view is assisting us at all!
    // the view is not coming back with its URL restored etc, as a UIWebView does

    override func decodeRestorableState(with coder: NSCoder) {
        print("decode")
        self.decoded = true
        super.decodeRestorableState(with:coder)
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        print("encode")
        super.encodeRestorableState(with:coder)
    }


    override func applicationFinishedRestoringState() {
        print("finished restoring state", self.wv.url as Any)
    }

    override func loadView() {
        print("loadView")
        super.loadView()
    }

    var obs = Set<NSKeyValueObservation>()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
                
        let wv = WKWebView(frame: CGRect.zero)
        wv.restorationIdentifier = "wv"
        self.view.restorationIdentifier = "wvcontainer" // shouldn't be necessary...
        wv.scrollView.backgroundColor = .black // web view alone, ineffective
        self.view.addSubview(wv)
        wv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:"H:|[wv]|", metrics: nil, views: ["wv":wv]),
            NSLayoutConstraint.constraints(withVisualFormat:"V:|[wv]|", metrics: nil, views: ["wv":wv])
            ].flatMap{$0})
        self.wv = wv
                
        // take advantage of built-in "back" and "forward" swipe gestures
        wv.allowsBackForwardNavigationGestures = true
        
        // prepare nice activity indicator to cover loading
        let act = UIActivityIndicatorView(style:.whiteLarge)
        act.backgroundColor = UIColor(white:0.1, alpha:0.5)
        self.activity = act
        wv.addSubview(act)
        act.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            act.centerXAnchor.constraint(equalTo:wv.centerXAnchor),
            act.centerYAnchor.constraint(equalTo:wv.centerYAnchor)
            ])
        obs.insert(wv.observe(\.isLoading, options: .new) { [unowned self] wv, ch in
            if let val = ch.newValue {
                if val {
                    self.activity.startAnimating()
                } else {
                    self.activity.stopAnimating()
                }
            }
        })
        // cool feature, show title
        obs.insert(wv.observe(\.title, options: .new) { [unowned self] wv, change in
            if let val = change.newValue, let title = val {
                self.navigationItem.title = title
            }
        })
        wv.navigationDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear, req: \(self.wv.url as Any)") // no evidence that restoration is being done for us
        
        let b = UIBarButtonItem(title:"Back", style:.plain, target:self, action:#selector(goBack))
        self.navigationItem.rightBarButtonItems = [b]
        
        if self.decoded {
            // return // forget it, just trying to see if I was in restoration's way, but I'm not
        }
        
        let url = URL(string: "http://www.apeth.com/RubyFrontierDocs/default.html")!
        self.wv.load(URLRequest(url:url))
    }
    

    deinit {
        print("dealloc")
    }
        
    @objc func goBack(_ sender: Any) {
        self.wv.goBack()
    }
    

}

extension WebViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation) {
        print("did commit \(navigation)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("did fail")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("did fail provisional")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("did finish")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("did start provisional")
    }
}

