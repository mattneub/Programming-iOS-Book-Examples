
import UIKit
import WebKit
import SafariServices

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
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
    func userContentController(_ ucc: WKUserContentController,
        didReceive message: WKScriptMessage) {
            self.delegate?.userContentController(ucc, didReceive: message)
    }
    deinit {
        print("message handler dealloc")
    }
}

final class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, UIViewControllerRestoration, SFSafariViewControllerDelegate {
    
    var activity = UIActivityIndicatorView()
    var oldOffset : CGPoint? // use nil as indicator
    var oldHTMLString : String?
    
    var obs = Set<NSKeyValueObservation>()
    
    var fontsize = 18
    var cssrule : String {
        return """
        var s = document.createElement('style');
        s.textContent = 'body { font-size: \(self.fontsize)px; }';
        document.documentElement.appendChild(s);
        """
    }
    @IBOutlet weak var wv : WKWebView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.restorationClass = type(of:self)
        self.edgesForExtendedLayout = [] // none, get accurate offset restoration
    }

    class func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        let id = identifierComponents.last!
        if id == "wvc" {
            print("recreating wvc view controller")
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wvc")
        }
        if id == "sf" {
            print("recreating safari view controller")
            if let url = coder.decodeObject(forKey: "safariurl") as? URL {
                return SFSafariViewController(url:url)
            }
            return nil
        }
        return nil
    }
    
    // we must save and restore offset ourselves
    // note that I don't touch the web view at this point: just an ivar
    // we don't have any web content yet!
    
    override func decodeRestorableState(with coder: NSCoder) {
        print("decode")
        super.decodeRestorableState(with:coder)
        let oldOffset = coder.decodeCGPoint(forKey: "oldOffset")
        print("retrieved old offset as \(oldOffset)")
        self.oldOffset = oldOffset // for local example
        
        let fontsize = coder.decodeInteger(forKey:"fontsize")
        self.fontsize = fontsize
        
        if let oldHTMLString = coder.decodeObject(forKey:"oldHTMLString") as? String {
            self.oldHTMLString = oldHTMLString
        }
        
        
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        print("encode")
        super.encodeRestorableState(with:coder)
        // we have to manage offset ourselves
        let off = self.wv.scrollView.contentOffset
        print("saving offset \(off)")
        coder.encode(off, forKey:"oldOffset")
        coder.encode(self.fontsize, forKey:"fontsize")
        coder.encode(self.oldHTMLString, forKey:"oldHTMLString")
        // are we presenting a safari view controller?
        if let _ = self.presentedViewController as? SFSafariViewController {
            if let url = self.safariurl {
                coder.encode(url, forKey:"safariurl") // failed experiment
            }
        }
    }
    
    override func applicationFinishedRestoringState() {
        print("finished restoring state") // still too soon to fix offset, not loaded yet
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // self.obs.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // a configuration consists of preferences (e.g. JavaScript behavior),
        // and a user content controller that allows JavaScript messages to be sent/received
        // it is copied, so if we supply one we can't change it later
        
        // prepare to receive messages under the "playbutton" name
        // unfortunately there's a bug: the script message handler cannot be self,
        // or we will leak
        
        
        var leak : Bool { return false }
        switch leak {
        case true:
            let config = self.wv.configuration
            config.userContentController.add(self, name: "playbutton")
        case false:
            let config = self.wv.configuration
            let handler = MyMessageHandler(delegate:self)
            config.userContentController.add(handler, name: "playbutton")
        }
        
        wv.configuration.applicationNameForUserAgent = "Version/1.0 MyShinyBrowser/1.0" // not working, too late?
        
        
        wv.restorationIdentifier = "wv"
        wv.scrollView.backgroundColor = .black // web view alone, ineffective

        wv.navigationDelegate = self
        
        // sorry, missing this feature
//        wv.paginationMode = .LeftToRight
//        wv.scrollView.pagingEnabled = true
        
        // prove we can attach gesture recognizer to web view's scroll view
        let swipe = UISwipeGestureRecognizer(target:self, action:#selector(swiped))
        swipe.direction = .left
        wv.scrollView.addGestureRecognizer(swipe)
        wv.allowsBackForwardNavigationGestures = false
        
        // prepare nice activity indicator to cover loading
        let act = UIActivityIndicatorView(style:.large)
        act.backgroundColor = UIColor(white:0.1, alpha:0.5)
        act.color = .white
        self.activity = act
        wv.addSubview(act)
        act.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            act.centerXAnchor.constraint(equalTo:wv.centerXAnchor),
            act.centerYAnchor.constraint(equalTo:wv.centerYAnchor)
            ])
        // webkit uses KVO
        // nb leak if we don't watch out for self
        obs.insert(wv.observe(\.isLoading, options: .new) { [unowned self] wv, ch in
            if let val = ch.newValue {
                if val {
                    print("starting animating")
                    self.activity.startAnimating()
                } else {
                    self.activity.stopAnimating()
                    print("stopping animating")
                    // for our *local* example, restoring offset is up to us
                    if self.oldOffset != nil { // local example
                        if wv.estimatedProgress == 1 {
                            delay(0.1) { // had to introduce delay; there's a flash but there's nothing I can do
                                print("finished loading! restoring offset")
                                wv.scrollView.contentOffset = self.oldOffset!
                                self.oldOffset = nil
                            }
                        }
                    }
                }
            }
        })
        // cool feature, show title
        obs.insert(wv.observe(\.title, options: .new) { wv, change in
            if let val = change.newValue, let title = val {
                print(title)
            }
        })
        
    }
    
    @objc func swiped(_ g:UIGestureRecognizer) {
        print("swiped") // okay, you proved it!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear, req: \(self.wv.url as Any)")
        delay(2) {
            print("wv scroll view delegate", self.wv.scrollView.delegate as Any)
        }

        if !self.isMovingToParent {
            return // so we don't do this again when a presented view controller is dismissed
        }
        
        var which : Int { return 1 } // 1; also 2-18 to test document types
        switch which {
        case 1:
            let b = UIBarButtonItem(title: "Size", style: .plain, target: self, action: #selector(doDecreaseSize))
            self.navigationItem.rightBarButtonItems = [b]
            
            // inject a CSS rule (example taken from WWDC 2014 video)
            // (instead of body style containing font-size:<fontsize>px; in template)
            
            do {
                let rule = self.cssrule
                let script = WKUserScript(source: rule, injectionTime: .atDocumentStart, forMainFrameOnly: true)
                let config = self.wv.configuration
                config.userContentController.addUserScript(script)
            }

            
            if let oldHTMLString = self.oldHTMLString {
                print("restoring html")
                
                let templatepath = Bundle.main.path(forResource: "htmlTemplate", ofType:"html")!
                let oldBase = URL(fileURLWithPath:templatepath)
                
                

                self.wv.loadHTMLString(oldHTMLString, baseURL:oldBase)
                return
            }
            
            let bodypath = Bundle.main.path(forResource: "htmlbody", ofType:"txt")!
            let ss = try! String(contentsOfFile:bodypath)
            
            let templatepath = Bundle.main.path(forResource: "htmlTemplate", ofType:"html")!
            let base = URL(fileURLWithPath:templatepath)
            var s = try! String(contentsOfFile:templatepath)
            
            s = s.replacingOccurrences(of:"<maximagewidth>", with:"80%")
            s = s.replacingOccurrences(of:"<margin>", with:"10")
            s = s.replacingOccurrences(of:"<guid>", with:"http://tidbits.com/article/12228")
            s = s.replacingOccurrences(of:"<ourtitle>", with:"Lion Details Revealed with Shipping Date and Price")
            // note way to set up messaging from web page's javascript to us
            s = s.replacingOccurrences(of:"<playbutton>", with:#"<img src="listen.png" onclick="window.webkit.messageHandlers.playbutton.postMessage('play')">"#)
            s = s.replacingOccurrences(of:"<author>", with:"TidBITS Staff")
            s = s.replacingOccurrences(of:"<date>", with:"Mon, 06 Jun 2011 13:00:39 PDT")
            s = s.replacingOccurrences(of:"<content>", with:ss)
            
            self.wv.loadHTMLString(s, baseURL:base) // works in iOS 9! local and remote images are loading
            self.oldHTMLString = s
        case 2:
            let path = Bundle.main.path(forResource: "release", ofType:"pdf")!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 3:
            let path = Bundle.main.path(forResource: "testing", ofType:"pdf")!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 4:
            let path = Bundle.main.path(forResource: "test", ofType:"rtf")!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 5:
            let path = Bundle.main.path(forResource: "test", ofType:"doc")!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 6:
            let path = Bundle.main.path(forResource: "test", ofType:"docx")!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 7:
            let path = Bundle.main.path(forResource: "test", ofType:"pages")! // blank on device
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 8:
            let path = Bundle.main.path(forResource: "test.pages", ofType:"zip")! // slow, but it does work!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 9:
            let path = Bundle.main.path(forResource: "test", ofType:"rtfd")! // blank on device
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 10:
            let path = Bundle.main.path(forResource: "test.rtfd", ofType:"zip")! // displays (new in iOS 10), but not the image
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 11:
            let path = Bundle.main.path(forResource: "htmlbody", ofType:"txt")!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 12:
            let url = URL(string: "http://www.apeth.com/rez/release.pdf")!
            self.wv.load(URLRequest(url: url))
        case 13:
            let url = URL(string: "http://www.apeth.com/rez/testing.pdf")!
            self.wv.load(URLRequest(url: url))
        case 14:
            let url = URL(string: "http://www.apeth.com/rez/test.rtf")!
            self.wv.load(URLRequest(url: url))
        case 15:
            let url = URL(string: "http://www.apeth.com/rez/test.doc")!
            self.wv.load(URLRequest(url: url))
        case 16:
            let url = URL(string: "http://www.apeth.com/rez/test.docx")!
            self.wv.load(URLRequest(url: url))
        case 17:
            let url = URL(string: "http://www.apeth.com/rez/test.pages.zip")!
            self.wv.load(URLRequest(url: url))
        case 18:
            let url = URL(string: "http://www.apeth.com/rez/test.rtfd.zip")! // iOS 10, text but not image
            self.wv.load(URLRequest(url: url))

        default: break
        }
        

    }
    
    // showing how to inject JavaScript dynamically (as opposed to at page-load time)
    
    @objc func doDecreaseSize (_ sender: Any) {
        self.fontsize -= 1
        if self.fontsize < 10 {
            self.fontsize = 20
        }
        let s = self.cssrule
        self.wv.evaluateJavaScript(s)
    }
    
    deinit {
        print("view controller dealloc")
        // self.obs.removeAll()
        // with webkit, probably no need for this, but no harm done
        // self.wv.stopLoading()
        // break all retains
        let ucc = self.wv.configuration.userContentController
        ucc.removeAllUserScripts() // not really needed, but whatever
        ucc.removeScriptMessageHandler(forName:"playbutton")
    }
    
    
    var safariurl : URL?
    // I injected a link to google myself into the HTML...
    // I expect to see the desktop version of the site in my web view, but I don't
    // aha, ok, I was able to get this to work perfectly by using Version/13.0.1 Safari/605.1.15
    // now we can have desktop or mobile as desired
    // wow this even works on an iPhone!
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
//        let preferences = WKWebpagePreferences()
//        preferences.preferredContentMode = .desktop
//        print("asking for desktop version")
//        decisionHandler(.allow, preferences)
//    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(navigation.effectiveContentMode.rawValue) // 2, but I'm still not seeing the desktop version
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        print("old here")
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                if url.scheme == "file" { // we do not scroll to anchor; bug in iOS 11?
                    decisionHandler(.allow)
                    return
                }
                print("user would like to navigate to \(url)")
                var whichNav : Int { return 1 }
                switch whichNav {
                case 0:
                    // this is how you would open in Mobile Safari
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    decisionHandler(.cancel)
                    return
                case 1:
                    // this is how to use the new Safari view controller
                    let svc = SFSafariViewController(url: url)
                    self.safariurl = url
                    svc.restorationIdentifier = "sf" // doesn't help
                    svc.restorationClass = type(of:self)
                    // svc.delegate = self
                    self.present(svc, animated: true)
                    decisionHandler(.cancel)
                    return
                default:break
                }
            }
        }
        // must always call _something_
        decisionHandler(.allow)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) { // new in iOS 9
        print("process did terminate") // but I do not know under what circumstances this will actually be called
    }

    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated:true)
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("loaded svc")
    }

    
    func userContentController(_ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage) {
            if message.name == "playbutton" {
                if let body = message.body as? String {
                    if body == "play" {
                        print("user would like to hear the podcast")
                    }
                }
            }
    }
}


