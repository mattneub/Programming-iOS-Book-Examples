

import UIKit

typealias MyDownloaderCompletion = (URL!) -> ()

class MyDownloader: NSObject, URLSessionDownloadDelegate {
    let config : URLSessionConfiguration
    let q = OperationQueue()
    let isMain = false // try false to move delegate methods onto a background thread
    lazy var session : URLSession = {
        let queue = (self.isMain ? .main : self.q)
        return URLSession(configuration:self.config, delegate:self, delegateQueue:queue)
    }()
    
    init(configuration config:URLSessionConfiguration) {
        self.config = config
        super.init()
    }
    
    @discardableResult
    func download(url:URL, completionHandler ch : @escaping MyDownloaderCompletion) -> URLSessionTask {
        let req = NSMutableURLRequest(url:url)
        URLProtocol.setProperty(ch as Any, forKey:"ch", in:req)
        let task = self.session.downloadTask(with:req as URLRequest)
        task.resume()
        return task
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo url: URL) {
        let req = downloadTask.originalRequest!
        let ch = URLProtocol.property(forKey:"ch", in:req) as! MyDownloaderCompletion
        if self.isMain {
            ch(url)
        } else {
            DispatchQueue.main.sync {
                ch(url)
            }
        }
    }
    
    func cancelAllTasks() {
        self.session.invalidateAndCancel()
    }
    
    deinit {
        print("farewell from MyDownloader")
    }
    
}

