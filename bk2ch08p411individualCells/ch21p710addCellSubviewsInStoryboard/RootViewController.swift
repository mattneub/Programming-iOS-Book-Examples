
import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class RootViewController : UITableViewController {
    
    let cellID = "Cell"
    
    var cells = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.tableView.rowHeight = 58 // *
        
        self.tableView.prefetchDataSource = self
        
        // test to see whether this causes cellForRowAt to be called if offscreen
        delay(2) {
            print("test reload")
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
            self.tableView.reloadRows(at: [IndexPath(row: 100, section: 0)], with: .none)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000 // make a lot of rows this time!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("will", indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("did end", indexPath.row)
    }
    
    // cellForRowAt can be called even if we are not immediately about to show
    // only will tells you that we are really about to show
    // we can prefetch data for an entire screenfull of adjacent cells...
    // but they are not created, and cellForRowAt will still need to configure them
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell", indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! MyCell

        let lab = cell.theLabel!
        // prove that many rows does not mean many cell objects
        lab.text = "Row \(indexPath.row) of section \(indexPath.section)"
        if lab.tag != 999 {
            lab.tag = 999
            self.cells += 1; print("New cell \(self.cells)")
        }

        
        let iv = cell.theImageView!
        
        // shrink apparent size of image
        let im = UIImage(named:"moi.png")!
        
        let r = UIGraphicsImageRenderer(size:CGSize(36,36), format:im.imageRendererFormat)
        let im2 = r.image {
            _ in im.draw(in:CGRect(0,0,36,36))
        }
        
        iv.image = im2
        iv.contentMode = .center

        
        return cell
    }
    
    
}

extension RootViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetch", indexPaths)
    }
}
