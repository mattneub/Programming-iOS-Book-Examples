

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var iv : UIImageView!
    
    let downloader : MyDownloader = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = false
        config.urlCache = nil
        return MyDownloader(configuration:config)
    }()
    
    @IBAction func doDownload (_ sender: Any!) {
        self.iv.image = nil
        let s = "https://www.nasa.gov/sites/default/files/styles/1600x1200_autoletterbox/public/pia17474_1.jpg"
        let url = URL(string:s)!
        self.downloader.download(url:url) { url in
            if let url = url, let d = try? Data(contentsOf: url) {
                let im = UIImage(data:d)
                self.iv.image = im
            }
        }
    }
    
    deinit {
        // self.downloader.cancelAllTasks()
        print("view controller dealloc")
    }
    
    
    
}
