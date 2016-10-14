
import UIKit

extension Notification.Name {
    static let gotProgress = Notification.Name("gotProgress")
    static let gotPicture = Notification.Name("gotPicture")
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, URLSessionDownloadDelegate {
                            
    var window: UIWindow?
    var image : UIImage!
    lazy var session : URLSession = {
        let id = "com.neuburg.matt.backgroundDownload"
        let config = URLSessionConfiguration.background(withIdentifier: id)
        config.allowsCellularAccess = false
        // could set config.isDiscretionary here
        let sess = URLSession(
            configuration: config, delegate: self, delegateQueue: .main)
        return sess
    }()
    var ch : (() -> ())!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        // Override point for customization after application launch.
        NSLog("%@", "launching")
        return true
    }
    
    func startDownload (_: Any?) {
        let s = "https://www.nasa.gov/sites/default/files/styles/1600x1200_autoletterbox/public/pia17474_1.jpg"
        let task = self.session.downloadTask(with:URL(string:s)!)
        task.resume()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let prog = Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)
        NSLog("%@", "downloaded \(100.0*prog)%")
        NotificationCenter.default.post(name: .gotProgress, object:self, userInfo:["progress":prog])
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let d = try? Data(contentsOf: location) else {return}
        let im = UIImage(data:d)
        DispatchQueue.main.async {
            NSLog("%@", "finished; posting notification")
            self.image = im
            NotificationCenter.default.post(name: .gotPicture, object: self)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        NSLog("%@", "completed; error: \(error)")
    }
    
    // === this is the Really Interesting Part
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        NSLog("%@", "hello hello, storing completion handler")
        self.ch = completionHandler
        _ = self.session // make sure we have one
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        self.ch?()
    }

}
