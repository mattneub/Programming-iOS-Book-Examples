

import UIKit

let isMain = false // try false to move delegate methods onto a background thread

typealias MyDownloaderCH = (URL?) -> ()

class MyDownloader: NSObject {
    let config : URLSessionConfiguration
    let dispatchq = DispatchQueue.global(qos:.background)
    let q : OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    lazy var session : URLSession = {
        let queue = (isMain ? .main : self.q)
        return URLSession(configuration:self.config, delegate:MyDownloaderDelegate(), delegateQueue:queue)
    }()
    init(configuration config:URLSessionConfiguration) {
        self.config = config
        super.init()
        print("printing on main thread")
    }
    
    @discardableResult
    func download(url:URL, completionHandler ch : @escaping MyDownloaderCH) -> URLSessionTask {
        let task = self.session.downloadTask(with:url)
        let del = self.session.delegate as! MyDownloaderDelegate
        del.appendHandler(ch, task: task, queue: isMain ? .main : self.q)
        task.resume()
        return task
    }
    
    private class MyDownloaderDelegate : NSObject, URLSessionDownloadDelegate {
        private var handlers = [Int:MyDownloaderCH]()
        func appendHandler(_ ch:@escaping MyDownloaderCH, task:URLSessionTask, queue:OperationQueue = .main) {
            queue.addOperation {
                print("adding completion for task \(task.taskIdentifier)")
                self.handlers[task.taskIdentifier] = ch
            }
        }
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo url: URL) {
            print("finished download for task \(downloadTask.taskIdentifier)")
            let ch = self.handlers[downloadTask.taskIdentifier]
            if isMain {
                ch?(url)
            } else {
                DispatchQueue.main.sync {
                    ch?(url)
                }
            }
        }
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            print("removing completion for task \(task.taskIdentifier)")
            self.handlers[task.taskIdentifier] = nil
        }
        deinit {
            print("farewell from Delegate", self.handlers.count)
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

