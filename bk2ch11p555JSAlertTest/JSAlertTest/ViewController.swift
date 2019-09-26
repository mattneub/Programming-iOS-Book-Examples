

import UIKit
import WebKit
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var wv : WKWebView!
    
    // failed experiment
    let datastore = WKWebsiteDataStore.default()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wv.allowsLinkPreview = true // just in case the storyboard isn't doing it
        
        self.wv.uiDelegate = self
        self.wv.navigationDelegate = self
        
        let s = """
        <html><head>
        <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
        </head>
        <body>
        <button onclick="myFunction()">Tap me</button>
        <button onclick="myFunction2()">And me</button>
        <br /><br />
        <p><a href="https://www.apple.com">Use 3D touch to peek and pop me.</a></p>
        <script>
        function myFunction() { alert("I am an alert box!"); }
        function myFunction2() { window.open("https://www.apple.com"); }
        </script>
        </body>
        </html>
        """
        
        wv.configuration.websiteDataStore = self.datastore
        wv.loadHTMLString(s, baseURL: nil)
    }
    var sfvc : SFSafariViewController?

}

extension ViewController : WKUIDelegate {
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        let host = frame.request.url?.host
        let alert = UIAlertController(title: host, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        })
        self.present(alert, animated:true)
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("no thanks, I'd rather not")
        return nil
    }
    
    // =======================
    
    // all of that is deprecated in iOS 13
    
    /*
    
    func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        if let url = elementInfo.linkURL {
            print("peeking")
            let sf = SFSafariViewController(url: url)
            return sf
        }
        return nil
    }
    func webView(_ webView: WKWebView, commitPreviewingViewController pvc: UIViewController) {
        print("popping")
        self.present(pvc, animated:true)
    }
 
 */
    
    // replacement is:
    
    /*
        func webView(_ webView: WKWebView, contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void)

        func webView(_ webView: WKWebView, contextMenuWillPresentForElement elementInfo: WKContextMenuElementInfo)

        func webView(_ webView: WKWebView, contextMenuForElement elementInfo: WKContextMenuElementInfo, willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating)

        func webView(_ webView: WKWebView, contextMenuDidEndForElement elementInfo: WKContextMenuElementInfo)
     }

     */
    
    // okay, so if allowsLinkPreview is true, we get peek and pop _automatically_
    // even if we don't implement anything further
    
    func webView(_ webView: WKWebView, contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: {
//            let config = SFSafariViewController.Configuration()
//            config.barCollapsingEnabled = false
//            let sfvc = SFSafariViewController(url: elementInfo.linkURL!, configuration:config)
//            self.sfvc = sfvc
//            return sfvc
            class WebViewController: UIViewController {
                let dataStore : WKWebsiteDataStore
                let url: URL
                init(dataStore: WKWebsiteDataStore, url:URL) {
                    self.dataStore = dataStore
                    self.url = url
                    super.init(nibName: nil, bundle: nil)
                }
                required init?(coder: NSCoder) {
                    fatalError("init(coder:) has not been implemented")
                }
                override func loadView() {
                    let config = WKWebViewConfiguration()
                    config.websiteDataStore = dataStore
                    self.view = WKWebView()
                    (self.view as! WKWebView).load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60))
                }
            }
            let wvc = WebViewController(dataStore: self.datastore, url: elementInfo.linkURL!)
            return wvc
        })
        { elements in
            let action = UIAction(title: "Test") { _ in
                print("Test")
            }
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [action])
            print(elements) // these are the default menu items
            return menu
        }
        //completionHandler(UIContextMenuConfiguration())
        completionHandler(config)
    }
    
    func webView(_ webView: WKWebView, contextMenuForElement elementInfo: WKContextMenuElementInfo, willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating) {
        animator.addAnimations {
//            if let sfvc = self.sfvc {
//                self.present(sfvc, animated: true)
//            }
            let url = elementInfo.linkURL!
            self.wv.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60))
        }
    }
    
    func webView(_ webView: WKWebView, contextMenuWillPresentForElement elementInfo: WKContextMenuElementInfo) {
        print("will present")
    }
    
    func webView(_ webView: WKWebView, contextMenuDidEndForElement elementInfo: WKContextMenuElementInfo) {
        print("did end")
    }
    
}

extension ViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        print("decide")
        decisionHandler(.allow, preferences)
    }
}


