

import UIKit
import WebKit
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var wv : WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wv.allowsLinkPreview = true // just in case the storyboard isn't doing it
        
        self.wv.uiDelegate = self
        
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
        
        wv.loadHTMLString(s, baseURL: nil)
    }
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
}


