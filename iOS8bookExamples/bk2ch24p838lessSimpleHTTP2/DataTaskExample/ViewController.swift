

import UIKit

class ViewController: UIViewController, NSURLSessionDataDelegate {

    @IBOutlet var iv : UIImageView!
    var task : NSURLSessionDataTask!
    var data = NSMutableData()
    
    lazy var session : NSURLSession = {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        config.allowsCellularAccess = false
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        return session
        }()
    
    @IBAction func doHTTP (sender:AnyObject!) {
        if self.task != nil {
            return
        }
        
        let s = "http://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = NSURL(string:s)!
        let req = NSMutableURLRequest(URL:url)
        let task = self.session.dataTaskWithRequest(req) // *
        self.task = task
        self.iv.image = nil
        self.data.length = 0 // *
        task.resume()
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        println("received \(data.length) bytes of data")
        // do something with the data here!
        self.data.appendData(data)
    }
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        println("completed: error: \(error)")
        self.task = nil
        if error == nil {
            self.iv.image = UIImage(data:self.data)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.finishTasksAndInvalidate()
        self.task = nil
    }
    
    deinit {
        println("farewell")
    }
    

    
}
