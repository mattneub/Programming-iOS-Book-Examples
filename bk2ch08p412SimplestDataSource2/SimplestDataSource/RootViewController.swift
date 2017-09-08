

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



class RootViewController: UITableViewController {
    
    let cellID = "Cell"
    
    var pep : [String]! = ["Manny", "Moe", "Jack"] // pretend model might not be ready
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
    }
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.pep == nil {
            return 0
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pep.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) 

        cell.textLabel!.text = pep[indexPath.row]
        return cell
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
