

import UIKit

/*
Passing a Swift block as an Objective-C object turns out to be very tricky.
You have to designate the block with the undocumented @objc_block attribute,
so it has the same size as an Objective-C block;
then you have to cast to AnyObject with the obscure built-in function unsafeBitCast()
and reverse that when you fetch it out, in order to call it
*/

typealias MyDownloaderCompletionHandler = @objc_block (NSURL!) -> ()

class MyDownloader: NSObject, NSURLSessionDownloadDelegate {
    let config : NSURLSessionConfiguration
    let q = NSOperationQueue()
    let main = true // try false to move delegate methods onto a background thread
    lazy var session : NSURLSession = {
        let queue = (self.main ? NSOperationQueue.mainQueue() : self.q)
        return NSURLSession(configuration:self.config, delegate:self, delegateQueue:queue)
    }()
    
    init(configuration config:NSURLSessionConfiguration) {
        self.config = config
        super.init()
    }
    
    func download(s:String, completionHandler ch : MyDownloaderCompletionHandler) -> NSURLSessionTask {
        let url = NSURL(string:s)!
        let req = NSMutableURLRequest(URL:url)
        let ch2 : AnyObject = unsafeBitCast(ch, AnyObject.self)
        NSURLProtocol.setProperty(ch2, forKey:"ch", inRequest:req)
        let task = self.session.downloadTaskWithRequest(req)
        task.resume()
        return task
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        println("downloaded \(100*writ/exp)%")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        // unused in this example
        println("did resume")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let req = downloadTask.originalRequest
        let ch : AnyObject = NSURLProtocol.propertyForKey("ch", inRequest:req)!
        let response = downloadTask.response as NSHTTPURLResponse
        let stat = response.statusCode
        println("status \(stat)")
        var url : NSURL! = nil
        if stat == 200 {
            url = location
            println("download \(req.URL.lastPathComponent)")
        }
        if self.main {
            unsafeBitCast(ch, MyDownloaderCompletionHandler.self)(url)
        } else {
            dispatch_sync(dispatch_get_main_queue()) {
                unsafeBitCast(ch, MyDownloaderCompletionHandler.self)(url)
            }
        }
    }
    
    func cancelAllTasks() {
        self.session.invalidateAndCancel()
    }
    
    deinit {
        println("farewell from MyDownloader")
    }
    
}

