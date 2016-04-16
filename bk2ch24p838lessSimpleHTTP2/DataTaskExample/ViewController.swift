

import UIKit

class ViewController: UIViewController, NSURLSessionDataDelegate {

    @IBOutlet var iv : UIImageView!
    var task : NSURLSessionDataTask!
    var data = NSMutableData()
    
    lazy var session : NSURLSession = {
        let config = NSURLSessionConfiguration.ephemeral()
        config.allowsCellularAccess = false
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.main())
        return session
        }()
    
    @IBAction func doHTTP (_ sender:AnyObject!) {
        if self.task != nil {
            return
        }
        
        let s = "http://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = NSURL(string:s)!
        let req = NSMutableURLRequest(url:url)
        let task = self.session.dataTask(with:req) // *
        self.task = task
        self.iv.image = nil
        self.data.length = 0 // *
        task.resume()
        
    }
    
    func urlSession(_ session: NSURLSession, dataTask: NSURLSessionDataTask, didReceive data: NSData) {
        print("received \(data.length) bytes of data")
        // do something with the data here!
        self.data.append(data)
    }
    
    
    func urlSession(_ session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        print("completed: error: \(error)")
        self.task = nil
        if error == nil {
            self.iv.image = UIImage(data:self.data)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.finishTasksAndInvalidate()
        self.task = nil
    }
    
    deinit {
        print("farewell")
    }
    

    
}
