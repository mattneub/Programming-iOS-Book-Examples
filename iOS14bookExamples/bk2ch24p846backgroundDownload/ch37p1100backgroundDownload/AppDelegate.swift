
import UIKit
import os.log

extension Notification.Name {
    static let gotPicture = Notification.Name("gotPicture")
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, URLSessionDownloadDelegate {
                            
    var window: UIWindow?
    var image : UIImage!
    lazy var session : URLSession = {
        let id = "com.neuburg.matt.backgroundDownload"
        let config = URLSessionConfiguration.background(withIdentifier: id)
        config.allowsExpensiveNetworkAccess = false
        // could set config.isDiscretionary here
        let sess = URLSession(
            configuration: config, delegate: self, delegateQueue: .main)
        return sess
    }()
    var ch : (() -> ())!
    // this really helps filter things in Console
    let log = OSLog(subsystem: "com.neuburg.matt", category: "testing")
    // states are active, inactive, background


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        // Override point for customization after application launch.
        os_log("launching", log: log)
        os_log("%{public}@", log: log, #function)
        return true
    }
    
    func startDownload (_: Any?) -> Progress {
        let s = "https://www.nasa.gov/sites/default/files/styles/1600x1200_autoletterbox/public/pia17474_1.jpg"
        let task = self.session.downloadTask(with:URL(string:s)!)
        task.earliestBeginDate = Date(timeIntervalSinceNow: 10)
        let progress = task.progress
        task.resume()
        os_log("resuming task", log: log)
        os_log("%{public}@", log: log, #function)
        return progress
    }
    
    // new in iOS 11
    // in real life, do _not_ implement this unless you need it, e.g.
    // because you might want to cancel the request before it starts,
    // or in order to substitute a different request
    // very interesting, but I believe this upsets the order;
    // this is called and then urlSessionDidFinishEvents, which is too soon
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        // dispositions are: .cancel, .continueLoading, .useNewRequest
        // and in the last case you supply a new request as the 2nd parameter
        os_log("will begin delayed request; now we are really starting %d", log: log, UIApplication.shared.applicationState.rawValue)
        os_log("%{public}@", log: log, #function)
        completionHandler(.continueLoading, nil)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let d = try? Data(contentsOf: location) else {return}
        os_log("finished; posting notification %d", log: log, UIApplication.shared.applicationState.rawValue)
        os_log("%{public}@", log: log, #function)
        let im = UIImage(data:d)
        DispatchQueue.main.async {
            self.image = im
            NotificationCenter.default.post(name: .gotPicture, object: self)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        os_log("did complete %d", log: log, UIApplication.shared.applicationState.rawValue)
        os_log("%{public}@", log: log, #function)
        if let err = error {
            os_log("%{public}@", log: log, err as NSError)
        }
    }
    
    // === this is the Really Interesting Part
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        os_log("hello hello, storing completion handler %d", log: log, UIApplication.shared.applicationState.rawValue)
        os_log("%{public}@", log: log, #function)
        self.ch = completionHandler
        _ = self.session // make sure we have one
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        os_log("did finish, calling completion handler %d", log: log, UIApplication.shared.applicationState.rawValue)
        os_log("%{public}@", log: log, #function)
        self.ch?()
    }

}
