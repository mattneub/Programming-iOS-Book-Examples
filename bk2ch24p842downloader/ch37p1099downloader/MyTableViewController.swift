

import UIKit

class MyTableViewController: UITableViewController, UITableViewDataSourcePrefetching {

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
        let mannyurl = "https://www.apeth.com/pep/manny.jpg"
        let jackurl = "https://www.apeth.com/pep/jack.jpg"
        let moeurl = "https://www.apeth.com/pep/moe.jpg"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.prefetchDataSource = self // turn on prefetching
    }
    
    var didSetup = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // work around bug: prefetch is not called for the initially visible rows!
        if !didSetup {
            didSetup = true
            if let ips = self.tableView.indexPathsForVisibleRows {
                self.tableView.prefetchDataSource?.tableView(self.tableView, prefetchRowsAt: ips)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for ip in indexPaths {
            let m = self.model[ip.row]
            guard m.im == nil else { print("nop \(ip)"); return } // we have a picture, nothing to do
            guard m.task == nil else { print("nop2 \(ip)"); return } // we're already downloading
            print("prefetching for \(ip)")
            m.task = self.downloader.download(m.picurl) { url in
                m.task = nil
                guard let url = url else { return }
                if let data = try? Data(contentsOf: url) {
                    m.im = UIImage(data:data)
                    DispatchQueue.main.async {
                        tableView.reloadRows(at:[ip], with: .none)
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        let m = self.model[indexPath.row]
        cell.textLabel!.text = m.text
        cell.imageView!.image = m.im // picture or nil
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
