
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NSURLSessionDownloadDelegate {
                            
    var window: UIWindow?
    var image : UIImage!
    lazy var session : NSURLSession = {
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(
            "com.neuburg.matt.ch37backgroundDownload")
        config.allowsCellularAccess = false
        // could set config.discretionary here
        let sess = NSURLSession(
            configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        return sess
    }()
    var ch : (() -> ())!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        NSLog("%@", "launching")
        return true
    }
    
    func startDownload (_:AnyObject?) {
        let s = "http://www.nasa.gov/sites/default/files/styles/1600x1200_autoletterbox/public/pia17474_1.jpg"
        let task = self.session.downloadTaskWithURL(NSURL(string:s)!)
        task.resume()
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let prog = Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)
        NSLog("%@", "downloaded \(100.0*prog)%")
        NSNotificationCenter.defaultCenter().postNotificationName("GotProgress", object:self, userInfo:["progress":prog])
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        guard let d = NSData(contentsOfURL: location) else {return}
        let im = UIImage(data:d)
        dispatch_async(dispatch_get_main_queue()) {
            NSLog("%@", "finished; posting notification")
            self.image = im
            NSNotificationCenter.defaultCenter().postNotificationName("GotPicture", object: self)
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        NSLog("%@", "completed; error: \(error)")
    }
    
    // === this is the Really Interesting Part
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        NSLog("%@", "hello hello, storing completion handler")
        self.ch = completionHandler
        let _ = self.session // make sure we have one
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        NSLog("%@", "calling completion handler")
        if self.ch != nil {
            self.ch()
        }
    }

}
