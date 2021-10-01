

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var wv : WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let sess = URLSession.shared
            let url = URL(string:"https://www.apple.com")!
            let task = sess.dataTask(with: url) { data, response, err in
                if let response = response,
                    let mime = response.mimeType,
                    let enc = response.textEncodingName,
                    let data = data {
                    print(mime, enc)
                }
            }
            task.resume()
        }

        
        var loadMethod : Int { return 3 }
        let url = Bundle.main.url(forResource: "failexample", withExtension: "html")!
        switch loadMethod {
        case 1: // doesn't work
            let s = try! String(contentsOf: url, encoding: .utf8)
            wv.loadHTMLString(s, baseURL: url)
        case 2: // works
            wv.loadFileURL(url, allowingReadAccessTo: url)
        case 3: // doesn't work
            let data = try! Data(contentsOf: url)
            wv.load(data, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: url)
        case 4: // works
            let req = URLRequest(url: url)
            wv.load(req)
        default:break
        }
        

    }



}

