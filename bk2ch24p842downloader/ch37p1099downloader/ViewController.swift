

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var iv : UIImageView!
    
    lazy var configuration : NSURLSessionConfiguration = {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        config.allowsCellularAccess = false
        config.URLCache = nil
        return config
        }()
    
    lazy var downloader : MyDownloader = {
        let d : MyDownloader = MyDownloader(configuration:self.configuration)
        return d
        }()
    
    @IBAction func doDownload (sender:AnyObject!) {
        self.iv.image = nil
        let s = "http://www.nasa.gov/sites/default/files/styles/1600x1200_autoletterbox/public/pia17474_1.jpg"
        self.downloader.download(s) {
            url in
            if url == nil {
                return
            }
            if let d = NSData(contentsOfURL: url) {
                let im = UIImage(data:d)
                dispatch_async(dispatch_get_main_queue()) {
                    self.iv.image = im
                }
            }
        }
    }
    
    deinit {
        self.downloader.cancelAllTasks()
        println("view controller dealloc")
    }
    
    
    
}
