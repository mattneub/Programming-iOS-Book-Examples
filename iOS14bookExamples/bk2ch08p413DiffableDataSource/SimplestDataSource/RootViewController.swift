

import UIKit
func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

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

struct Pep : Hashable {
    let name : String
    let imageName : String
}

class RootViewController: UITableViewController {
    
    let cellID = "Cell"
    lazy var datasource : UITableViewDiffableDataSource<Int,Pep> =
        UITableViewDiffableDataSource(tableView: self.tableView) {
            tv,ip,pep in
            let cell = tv.dequeueReusableCell(withIdentifier: self.cellID, for: ip)
            cell.textLabel!.text = pep.name
            cell.imageView!.image = UIImage(named:pep.imageName)
            return cell
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pep : [Pep] = [
            Pep(name: "Manny", imageName: "manny.jpg"),
            Pep(name: "Moe", imageName: "moe.jpg"),
            Pep(name: "Jack", imageName: "jack.jpg")
        ]
        var snap = NSDiffableDataSourceSnapshot<Int,Pep>()
        snap.appendSections([0])
        snap.appendItems(pep)
        self.datasource.apply(snap, animatingDifferences: false)
        
        self.title = "Big Title"
        
        // can be configured in nib editor, but let's do it here
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(doRefresh), for: .valueChanged)
        
        // this is also still the table view controller's refresh control
        // this works properly only in a table view controller context anyway
        
        let v = UIView()
        v.backgroundColor = .yellow
        self.tableView.backgroundView = v
        // don't do this! you'll get a horrible mess
//        self.tableView.refreshControl?.backgroundColor = .green
        
        // it is also absolutely essential that the table view controller
        // extends its view up behind the navigation bar!
        // again, can do this in nib editor
        
        self.edgesForExtendedLayout = .all
        
        self.tableView.contentInsetAdjustmentBehavior = .always
        
        // self.navigationItem.largeTitleDisplayMode = .never
        
        // NB ok to register cell _after_ supplying data to data source
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        
    }
    


    @IBAction func doRefresh(_ sender: Any) {
        print("refreshing...")
        delay(3) {
            (sender as! UIRefreshControl).endRefreshing()
            print("done")
        }
    }
    
    @IBAction func doRefreshManually(_ sender: Any) {
        // I find it odd that you still have to do this, but hey
        // also bar stays too big; I don't like that but I don't see what I can do about it
        
        self.refreshControl!.sizeToFit()
        let top = self.tableView.adjustedContentInset.top
        let y = self.refreshControl!.frame.maxY + top
        self.tableView.setContentOffset(CGPoint(0, -y), animated:true)

        self.refreshControl!.beginRefreshing()
        self.doRefresh(self.refreshControl!)
    }
}
