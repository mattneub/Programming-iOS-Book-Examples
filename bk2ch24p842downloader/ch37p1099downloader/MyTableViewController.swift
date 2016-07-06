

import UIKit

class MyTableViewController: UITableViewController {

    lazy var configuration : URLSessionConfiguration = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = false
        config.urlCache = nil
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
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
                    m.task = nil // *
                    if url == nil {
                        return
                    }
                    if let data = try? Data(contentsOf: url) {
                        let im = UIImage(data:data)
                        m.im = im
                        DispatchQueue.main.async {
                            self!.tableView.reloadRows(at:[indexPath], with: .none)
                        }
                    }
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let m = self.model[(indexPath as NSIndexPath).row]
        if let task = m.task {
            if task.state == .running {
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
    var task : URLSessionTask!
}
