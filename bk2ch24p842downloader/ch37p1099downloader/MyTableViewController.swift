

import UIKit

class MyTableViewController: UITableViewController, UITableViewDataSourcePrefetching {

    lazy var configuration : URLSessionConfiguration = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsExpensiveNetworkAccess = false
        config.urlCache = nil
        return config
        }()
    
    lazy var downloader : Downloader = {
        return Downloader(configuration:self.configuration)
    }()

    var model : [Model] = {
        let mannyurl = URL(string:"https://www.apeth.com/pep/manny.jpg")!
        let jackurl = URL(string:"https://www.apeth.com/pep/jack.jpg")!
        let moeurl = URL(string:"https://www.apeth.com/pep/moe.jpg")!
        var arr = [Model]()
        for _ in 0 ..< 15 {
            let m = Model (
                text : "Manny",
                picurl : mannyurl
            )
            arr.append(m)
//        }
//        for _ in 0 ..< 15 {
            let m2 = Model (
                text : "Moe",
                picurl : moeurl
            )
            arr.append(m2)
//        }
//        for _ in 0 ..< 15 {
            let m3 = Model (
                text : "Jack",
                picurl : jackurl
            )
            arr.append(m3)
        }
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.prefetchDataSource = self // turn on prefetching
    }
    
    var didSetup = false
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for ip in indexPaths {
            let m = self.model[ip.row]
            guard m.im == nil else { print("nop \(ip)"); continue } // we have an image, nothing to do
            guard m.task == nil else { print("nop2 \(ip)"); continue } // we're already downloading
            print("prefetching for \(ip)")
            m.task = self.downloader.download(url:m.picurl) { url in
                m.task = nil
                if let url = url, let data = try? Data(contentsOf: url) {
                    print("got \(ip)")
                    m.im = UIImage(data:data)
                    tableView.reloadRows(at:[ip], with: .none)
                }
            }
        }
    }
    
	let cellID = "Cell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let m = self.model[indexPath.row]
        cell.textLabel?.text = m.text
        cell.imageView?.image = m.im // image or nil
        if m.task == nil && m.im == nil {
            // I regard the need for this as a bug in the prefetch architecture
            self.tableView(tableView, prefetchRowsAt:[indexPath])
        }
        return cell
    }
    
    // uncomment to try expunging
   /*
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let m = self.model[(indexPath as NSIndexPath).row]
        if m.task == nil && m.im != nil {
            m.im = nil // expunge
        }
    }
 */
    
    deinit {
        print("table view controller dealloc")
    }

}

// unfortunately a Swift dictionary inside an array is effectively immutable
// but we need to mutate our model objects
// one solution would be to resort to NSMutableDictionary
// but the truth is that this should have been a simple value class all along, so here it is

class Model {
    init(text: String, picurl: URL) {
        self.text = text
        self.picurl = picurl
    }
    var text : String
    var picurl : URL
    var im : UIImage?
    var task : URLSessionTask?
}
