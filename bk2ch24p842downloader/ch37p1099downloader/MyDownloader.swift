

import UIKit

// tried to get rid of Wrapper, but failed
class Wrapper<T> {
    let p:T
    init(_ p:T){self.p = p}
}

// must be @objc_block or we won't get memory management on background thread
typealias MyDownloaderCompletion = @convention(block) (URL!) -> ()

class MyDownloader: NSObject, URLSessionDownloadDelegate {
    let config : URLSessionConfiguration
    let q = OperationQueue()
    let isMain = true // try false to move delegate methods onto a background thread
    lazy var session : URLSession = {
        let queue = (self.isMain ? .main : self.q)
        return URLSession(configuration:self.config, delegate:self, delegateQueue:queue)
    }()
    
    init(configuration config:URLSessionConfiguration) {
        self.config = config
        super.init()
    }
    
    @discardableResult
    func download(url:URL, completionHandler ch : MyDownloaderCompletion) -> URLSessionTask {
        let req = NSMutableURLRequest(url:url)
        URLProtocol.setProperty(Wrapper(ch), forKey:"ch", in:req)
        let task = self.session.downloadTask(with:req as URLRequest)
        task.resume()
        return task
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo url: URL) {
        let req = downloadTask.originalRequest!
        let w = URLProtocol.property(forKey:"ch", in:req)!
//        let response = downloadTask.response as! HTTPURLResponse
//        let stat = response.statusCode
//        print("status \(stat)")
//        var url : URL! = nil
//        if stat == 200 {
//            url = location
//            print("download \(req.url!.lastPathComponent)")
//        }
        if let w = (w as? Wrapper<MyDownloaderCompletion>) {
            let ch = w.p
            if self.isMain {
                ch(url)
            } else {
                DispatchQueue.main.sync {
                    ch(url)
                }
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

