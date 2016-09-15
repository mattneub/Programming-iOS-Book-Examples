

import UIKit

class ViewController: UIViewController, NSURLSessionDownloadDelegate {

    @IBOutlet var iv : UIImageView!
    var task : NSURLSessionTask!
    
    let which = 1 // 0 or 1
    
    lazy var session : NSURLSession = {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        config.allowsCellularAccess = false
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        return session
    }()

    
    
    @IBAction func doElaborateHTTP (sender:AnyObject!) {
        if self.task != nil {
            return
        }
        
        let s = "http://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = NSURL(string:s)!
        let req = NSMutableURLRequest(URL:url)
        if which == 1 { // show how to attach stuff to the request
            NSURLProtocol.setProperty("howdy", forKey:"greeting", inRequest:req)
        }
        let task = self.session.downloadTaskWithRequest(req)
        self.task = task
        self.iv.image = nil
        task.resume()

    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        print("downloaded \(100*writ/exp)%")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        // unused in this example
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        print("completed: error: \(error)")
    }
    
    // this is the only required NSURLSessionDownloadDelegate method

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        if which == 1 {
            let req = downloadTask.originalRequest!
            if let greeting = NSURLProtocol.propertyForKey("greeting", inRequest:req) as? String {
                print(greeting)
            }
        }
        self.task = nil
        let response = downloadTask.response as! NSHTTPURLResponse
        let stat = response.statusCode
        print("status \(stat)")
        if stat != 200 {
            return
        }
        let d = NSData(contentsOfURL:location)!
        let im = UIImage(data:d)
        dispatch_async(dispatch_get_main_queue()) {
            self.iv.image = im
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.finishTasksAndInvalidate()
    }
    
    deinit {
        print("farewell")
    }
    
}
