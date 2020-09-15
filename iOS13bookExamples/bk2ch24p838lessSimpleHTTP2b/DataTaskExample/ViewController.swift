

import UIKit

class ViewController: UIViewController, URLSessionDataDelegate {

    @IBOutlet var iv : UIImageView!
    var data = [Int:Data]()
    
    lazy var session : URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsExpensiveNetworkAccess = false
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        config.httpMaximumConnectionsPerHost = 2
        let queue = OperationQueue()
        let session = URLSession(configuration: config, delegate: self, delegateQueue: queue)
        return session
        }()
    
    @IBAction func doHTTP (_ sender: Any) {
        self.iv.image = nil
        let s = "https://www.nasa.gov/sites/default/files/styles/1600x1200_autoletterbox/public/pia17474_1.jpg"
        let url = URL(string:s)!
        let req = URLRequest(url:url)
        let task = self.session.dataTask(with:req) // *
        self.data[task.taskIdentifier] = Data() // *
        task.resume()
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // do something with the data here!
        self.data[dataTask.taskIdentifier]!.append(data)
        print("""
        \(dataTask.taskIdentifier) received \
        \(data.count) bytes of data; total \
        \(self.data[dataTask.taskIdentifier]!.count)
        """
        )
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("completed: error: \(error as Any)")
        let d = self.data[task.taskIdentifier]!
        self.data[task.taskIdentifier] = nil
        if error == nil {
            DispatchQueue.main.async {
                self.iv.image = UIImage(data:d)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.finishTasksAndInvalidate()
    }
    
    deinit {
        print("farewell")
    }
    

    
}
