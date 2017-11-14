

import UIKit

let isMain = false // try false to move delegate methods onto a background thread

typealias MyDownloaderCompletion = (URL?) -> ()

// decided to give up the URLProtocol approach
// ... and just keep an array of completion handlers in the delegate

class MyDownloader: NSObject {
    let config : URLSessionConfiguration
    let q = OperationQueue()
    lazy var session : URLSession = {
        let queue = (isMain ? .main : self.q)
        return URLSession(configuration:self.config, delegate:MyDownloaderDelegate(), delegateQueue:queue)
    }()
    init(configuration config:URLSessionConfiguration) {
        self.config = config
        super.init()
    }
    
    @discardableResult
    func download(url:URL, completionHandler ch : @escaping MyDownloaderCompletion) -> URLSessionTask {
        let req = NSMutableURLRequest(url:url)
        URLProtocol.setProperty(ch, forKey:"ch", in:req)
        let task = self.session.downloadTask(with:req as URLRequest)
        task.resume()
        return task
    }
    
    private class MyDownloaderDelegate : NSObject, URLSessionDownloadDelegate {
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo url: URL) {
            let req = downloadTask.originalRequest!
            let ch = URLProtocol.property(forKey:"ch", in:req) as! MyDownloaderCompletion
            if isMain {
                ch(url)
            } else {
                DispatchQueue.main.sync {
                    ch(url)
                }
            }
        }
        deinit {
            print("farewell from Delegate")
        }
    }

    
//    func cancelAllTasks() {
//        self.session.invalidateAndCancel()
//    }
    
    deinit {
        print("farewell from MyDownloader")
        self.session.invalidateAndCancel()
    }
    
}

