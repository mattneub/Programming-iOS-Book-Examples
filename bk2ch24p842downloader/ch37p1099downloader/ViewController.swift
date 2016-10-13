

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var iv : UIImageView!
    
    lazy var configuration : URLSessionConfiguration = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = false
        config.urlCache = nil
        return config
        }()
    
    lazy var downloader : MyDownloader = {
        let d : MyDownloader = MyDownloader(configuration:self.configuration)
        return d
        }()
    
    @IBAction func doDownload (_ sender: Any!) {
        self.iv.image = nil
        let s = "https://www.nasa.gov/sites/default/files/styles/1600x1200_autoletterbox/public/pia17474_1.jpg"
        self.downloader.download(s) { url in
            if let url = url, let d = try? Data(contentsOf: url) {
                let im = UIImage(data:d)
                DispatchQueue.main.async {
                    self.iv.image = im
                }
            }
        }
    }
    
    deinit {
        self.downloader.cancelAllTasks()
        print("view controller dealloc")
    }
    
    
    
}
