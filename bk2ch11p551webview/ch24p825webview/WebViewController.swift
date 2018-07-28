
import UIKit

class WebViewController: UIViewController, UIWebViewDelegate, UIViewControllerRestoration {
    
    var activity = UIActivityIndicatorView()
    var oldOffset : NSValue? // use nil as indicator
    
    var canNavigate = false // distinguish the two examples, local and remote content
    
    var wv : UIWebView {
        return self.view as! UIWebView
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "wvc"
        self.restorationClass = type(of:self)
        let b = UIBarButtonItem(title:"Back", style:.plain, target:self, action:#selector(goBack))
        self.navigationItem.rightBarButtonItem = b
        self.edgesForExtendedLayout = [] // none; get accurate offset restoration
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    class func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        return self.init(nibName:nil, bundle:nil)
    }
    
    // for the local page example, we must save and restore offset ourselves
    // note that I don't touch the web view at this point: just an ivar
    // we don't have any web content yet!

    override func decodeRestorableState(with coder: NSCoder) {
        print("decode")
        super.decodeRestorableState(with:coder)
        self.oldOffset = coder.decodeObject(forKey:"oldOffset") as? NSValue // for local example
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        print("encode")
        super.encodeRestorableState(with:coder)
        if !self.canNavigate { // local example; we have to manage offset ourselves
            print("saving offset")
            let off = self.wv.scrollView.contentOffset
            coder.encode(NSValue(cgPoint:off), forKey:"oldOffset")
        }
    }
    
    override func applicationFinishedRestoringState() {
        if self.wv.request != nil {
            // remote example
            self.wv.reload()
        }
    }
    
    deinit {
        print("dealloc")
        self.wv.stopLoading()
        self.wv.delegate = nil
    }
    
    override func loadView() {
        let wv = UIWebView()
        wv.restorationIdentifier = "wv"
        wv.backgroundColor = .black
        self.view = wv
        wv.delegate = self
        
        // new iOS 7 feature! uncomment to try it
//        wv.paginationMode = .LeftToRight
//        wv.scrollView.pagingEnabled = true
        
        // prove that we can attach gesture recognizer to web view's scroll view
        let swipe = UISwipeGestureRecognizer(target:self, action:#selector(swiped))
        swipe.direction = .left
        wv.scrollView.addGestureRecognizer(swipe)
        
        // prepare nice activity indicator to cover loading
        let act = UIActivityIndicatorView(style:.whiteLarge)
        act.backgroundColor = UIColor(white:0.1, alpha:0.5)
        self.activity = act
        wv.addSubview(act)
        act.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(
            NSLayoutConstraint(item: act, attribute: .centerX, relatedBy: .equal, toItem: wv, attribute: .centerX, multiplier: 1, constant: 0)
        )
        self.view.addConstraint(
            NSLayoutConstraint(item: act, attribute: .centerY, relatedBy: .equal, toItem: wv, attribute: .centerY, multiplier: 1, constant: 0)
        )
    }
    
    @objc func swiped(_ g:UIGestureRecognizer) {
        print("swiped") // okay, you proved it
    }
    
    let LOADREQ = 0 // 0, or try 1 for a different application...
    // one that loads an actual request and lets you experiment with state saving and restoration
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear, req: \(self.wv.request as Any)")
        
        if LOADREQ == 1 {
            self.canNavigate = true
            if self.wv.request != nil { // let applicationFinished handle reloading
                return
            }
            let url = URL(string: "http://www.apeth.com/RubyFrontierDocs/default.html")!
            self.wv.loadRequest(URLRequest(url:url))
            return
        }
        
        var which : Int {return 10}
        switch which {
        case 1:
            let path = Bundle.main.path(forResource: "htmlbody", ofType:"txt")!
            let base = URL(fileURLWithPath:path)
            let ss = try! String(contentsOfFile:path)
            
            let path2 = Bundle.main.path(forResource: "htmlTemplate", ofType:"txt")!
            var s = try! String(contentsOfFile:path2)
            
            s = s.replacingOccurrences(of:"<maximagewidth>", with:"80%")
            s = s.replacingOccurrences(of:"<fontsize>", with:"18")
            s = s.replacingOccurrences(of:"<margin>", with:"10")
            s = s.replacingOccurrences(of:"<guid>", with:"http://tidbits.com/article/12228")
            s = s.replacingOccurrences(of:"<ourtitle>", with:"Lion Details Revealed with Shipping Date and Price")
            s = s.replacingOccurrences(of:"<playbutton>", with:"<img src=\"listen.png\" onclick=\"document.location='play:me'\">")
            s = s.replacingOccurrences(of:"<author>", with:"TidBITS Staff")
            s = s.replacingOccurrences(of:"<date>", with:"Mon, 06 Jun 2011 13:00:39 PDT")
            s = s.replacingOccurrences(of:"<content>", with:ss)
            
            self.wv.loadHTMLString(s, baseURL:base)
        case 2:
            let path = Bundle.main.path(forResource: "release", ofType:"pdf")! // works in simulator, works in device
            let url = URL(fileURLWithPath:path)
            self.wv.loadRequest(URLRequest(url: url))
        case 3:
            let path = Bundle.main.path(forResource: "testing", ofType:"pdf")! // works in simulator, works in device
            let url = URL(fileURLWithPath:path)
            self.wv.loadRequest(URLRequest(url: url))
        case 4:
            let path = Bundle.main.path(forResource: "test", ofType:"rtf")! // works in simulator, works in device (iOS 8.3, I think it was fixed in 8.1)
            let url = URL(fileURLWithPath:path)
            self.wv.loadRequest(URLRequest(url: url))
        case 5:
            let path = Bundle.main.path(forResource: "test", ofType:"doc")! // works in simulator, works on device!
            let url = URL(fileURLWithPath:path)
            self.wv.loadRequest(URLRequest(url: url))
        case 6:
            let path = Bundle.main.path(forResource: "test", ofType:"docx")!  // works in simulator, works on device
            let url = URL(fileURLWithPath:path)
            self.wv.loadRequest(URLRequest(url: url))
        case 7:
            let path = Bundle.main.path(forResource: "test", ofType:"pages")! // blank in simulator, blank on device, no message :(
            let url = URL(fileURLWithPath:path)
            self.wv.loadRequest(URLRequest(url: url))
        case 8:
            let path = Bundle.main.path(forResource: "test.pages", ofType:"zip")! // works in simulator! works on device, but unbelievably slow
            let url = URL(fileURLWithPath:path)
            self.wv.loadRequest(URLRequest(url: url))
        case 9:
            let path = Bundle.main.path(forResource: "test", ofType:"rtfd")! // blank in simulator, blank on device, no message
            let url = URL(fileURLWithPath:path)
            self.wv.loadRequest(URLRequest(url: url))
        case 10:
            let path = Bundle.main.path(forResource: "test.rtfd", ofType:"zip")! // blank in simulator, blank on device, "Unable to read document" displayed
            // whoa! in iOS 10 I see the document! However, I don't see the embedded image
            let url = URL(fileURLWithPath:path)
            // let data = try! Data.init(contentsOf: url)
            self.wv.loadRequest(URLRequest(url: url))
            // next line: nice try, but I still don't see the image, though now I do see its name
            // self.wv.load(data, mimeType: "application/zip", textEncodingName: "utf-8", baseURL: url)
        case 11:
            let path = Bundle.main.path(forResource: "htmlbody", ofType:"txt")! // works in simulator, works in device (as text, of course)
            let url = URL(fileURLWithPath:path)
            self.wv.loadRequest(URLRequest(url: url))
        default:break
        }

        

    }
    
    func webViewDidStartLoad(_ wv: UIWebView) {
        self.activity.startAnimating()
    }
    
    func webViewDidFinishLoad(_ wv: UIWebView) {
        self.activity.stopAnimating()
        // for our *local* example, restoring offset is up to us
        if self.oldOffset != nil && !self.canNavigate { // local example
            print("restoring offset")
            wv.scrollView.contentOffset = self.oldOffset!.cgPointValue
        }
        self.oldOffset = nil
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.activity.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith r: URLRequest, navigationType nt: UIWebView.NavigationType) -> Bool {
        if let scheme = r.url?.scheme, scheme == "play" {
            print("user would like to hear the podcast")
            return false
        }
        if nt == .linkClicked { // disable link-clicking
            if self.canNavigate {
                return true
            }
            print("user would like to navigate to \(r.url as Any)")
            // this is how you would open in Mobile Safari
            // UIApplication.shared.openURL(r.URL)
            return false
        }
        return true
    }
    
    @objc func goBack(_ sender: Any) {
        if self.wv.canGoBack {
            self.wv.goBack()
        }
    }
}
