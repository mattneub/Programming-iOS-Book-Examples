

import UIKit

class ViewController: UIViewController, URLSessionDataDelegate {

    @IBOutlet var iv : UIImageView!
    var task : URLSessionDataTask!
    var data = Data()
    
    lazy var session : URLSession = {
        let config = URLSessionConfiguration.ephemeral()
        config.allowsCellularAccess = false
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main())
        return session
        }()
    
    @IBAction func doHTTP (_ sender:AnyObject!) {
        if self.task != nil {
            return
        }
        
        let s = "http://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string:s)!
        let req = URLRequest(url:url)
        let task = self.session.dataTask(with:req) // *
        self.task = task
        self.iv.image = nil
        self.data.count = 0 // *
        task.resume()
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("received \(data.count) bytes of data")
        // do something with the data here!
        self.data.append(data)
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
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
