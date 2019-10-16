

import UIKit
import WebKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}

class SchemeHandler : NSObject, WKURLSchemeHandler {
    deinit { print("farewell from scheme handler") }
    var sch : String?
    func webView(_ webView: WKWebView, start task: WKURLSchemeTask) {
        print(task.request) // called twice, I've no idea why
        if let url = task.request.url,
            let sch = self.sch,
            url.scheme == sch,
            let host = url.host,
            let theme = NSDataAsset(name:host) {
            let data = theme.data
            let resp = URLResponse(url: url, mimeType: "audio/mpeg",
                                   expectedContentLength: data.count,
                                   textEncodingName: nil)
            task.didReceive(resp)
            task.didReceive(data)
            task.didFinish()
            print("supplied data")
        } else {
            task.didFailWithError(NSError(domain: "oops", code: 0))
        }
    }
    
    func webView(_ webView: WKWebView, stop task: WKURLSchemeTask) {
        print("stop")
    }

    
}

class ViewController: UIViewController {
    weak var wv: WKWebView!
    
    let sch = "neuburg-custom-scheme-demo-audio"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let config = WKWebViewConfiguration()
        let sh = SchemeHandler()
        sh.sch = self.sch

        // this feature works only if you complete the configuration _before_ making the web view
        var before : Bool { return true } // demonstrate that fact
        
        switch before {
        case true:
            config.setURLSchemeHandler(sh, forURLScheme: self.sch)
        default:break
        }
        
        let wv = WKWebView(frame: CGRect(30,30,200,300), configuration: config)
        self.view.addSubview(wv)
        self.wv = wv
        
        switch before {
        case false:
            self.wv?.configuration.setURLSchemeHandler(sh, forURLScheme: self.sch)
            // doesn't work
        default:break
        }

        let s = """
        <!DOCTYPE html><html><head>
        <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
        </head><body>
        <p>Here you go:</p>
        <audio controls>
        <source src="\(sch)://theme" />
        </audio>
        </body></html>
        """
        print(s)
        self.wv.loadHTMLString(s, baseURL: nil)

    }
    
    deinit {
        print("farewell")
    }
}

