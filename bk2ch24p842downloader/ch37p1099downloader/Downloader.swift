

import UIKit

let isMain = false // try false to move delegate methods onto a background thread

typealias DownloaderCH = (URL?) -> ()

class Downloader: NSObject {
    let config : URLSessionConfiguration
    let dispatchq = DispatchQueue.global(qos:.background)
    let queue : OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }()
    lazy var session : URLSession = {
        let queue = (isMain ? .main : self.queue)
        return URLSession(configuration:self.config, delegate:DownloaderDelegate(), delegateQueue:queue)
    }()
    init(configuration config:URLSessionConfiguration) {
        self.config = config
        super.init()
        print("printing on main thread")
    }
    
    @discardableResult
    func download(url:URL, completionHandler ch : @escaping DownloaderCH) -> URLSessionTask {
        let task = self.session.downloadTask(with:url)
        let del = self.session.delegate as! DownloaderDelegate
        // make sure we never speak to DownloaderDelegate except on its own queue
        self.session.delegateQueue.addOperation {
            del.appendHandler(ch, task: task)
        }
        // is it safe to resume and return task immediately?
        // yes! the queue is a serial queue;
        // therefore no delegate messages can arrive until after appendHandler executes
        task.resume()
        return task
    }
    
    private class DownloaderDelegate : NSObject, URLSessionDownloadDelegate {
        private var handlers = [Int:DownloaderCH]()
        func appendHandler(_ ch:@escaping DownloaderCH, task:URLSessionTask) {
            print("adding completion for task \(task.taskIdentifier)")
            self.handlers[task.taskIdentifier] = ch
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
            // if error != nil { self.handlers[task.taskIdentifier]?(nil) } // for book, one line grace
            let ch = self.handlers[task.taskIdentifier]
            self.handlers[task.taskIdentifier] = nil
            // whoa, this is a flaw in the book and example code too; need to return nil if we get error
            if let error = error {
                print("error?", error)
                if isMain {
                    ch?(nil)
                } else {
                    DispatchQueue.main.sync {
                        ch?(nil)
                    }
                }
            }
        }
        deinit {
            print("farewell from Delegate", self.handlers.count)
        }
    }

    
//    func cancelAllTasks() {
//        self.session.invalidateAndCancel()
//    }
    
    deinit {
        print("farewell from Downloader")
        self.session.invalidateAndCancel()
    }
    
}

