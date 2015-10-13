

import UIKit

class MyTableViewController: UITableViewController {

    lazy var configuration : NSURLSessionConfiguration = {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        config.allowsCellularAccess = false
        config.URLCache = nil
        return config
        }()
    
    lazy var downloader : MyDownloader = {
        return MyDownloader(configuration:self.configuration)
        }()

    var model : [Model] = {
        let mannyurl = "http://www.apeth.com/pep/manny.jpg"
        let jackurl = "http://www.apeth.com/pep/jack.jpg"
        let moeurl = "http://www.apeth.com/pep/moe.jpg"
        var arr = [Model]()
        for _ in 0 ..< 15 {
            let m = Model()
            m.text = "Manny"
            m.picurl = mannyurl
            arr.append(m)
        }
        for _ in 0 ..< 15 {
            let m = Model()
            m.text = "Moe"
            m.picurl = moeurl
            arr.append(m)
        }
        for _ in 0 ..< 15 {
            let m = Model()
            m.text = "Jack"
            m.picurl = jackurl
            arr.append(m)
        }
        return arr
    }()
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)
        let m = self.model[indexPath.row]
        cell.textLabel!.text = m.text
        // have we got a picture?
        if let im = m.im {
            cell.imageView!.image = im
        } else {
            if m.task == nil { // no task? start one!
                cell.imageView!.image = nil
                m.task = self.downloader.download(m.picurl) { // *
                    [weak self] url in // *
                    m.task == nil // *
                    if url == nil {
                        return
                    }
                    let data = NSData(contentsOfURL: url)!
                    let im = UIImage(data:data)
                    m.im = im
                    dispatch_async(dispatch_get_main_queue()) {
                        self!.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    }
                }
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let m = self.model[indexPath.row]
        if let task = m.task {
            if task.state == .Running {
                task.cancel()
                print("cancel task for row \(indexPath.row)")
                m.task = nil
            }
        }
    }
    
    deinit {
        self.downloader.cancelAllTasks()
        print("table view controller dealloc")
    }

}

// unfortunately a Swift dictionary inside an array is effectively immutable
// but we need to mutate our model objects
// one solution would be to resort to NSMutableDictionary
// but the truth is that this should have been a simple value class all along, so here it is

class Model {
    var text : String!
    var im : UIImage!
    var picurl : String!
    var task : NSURLSessionTask!
}
