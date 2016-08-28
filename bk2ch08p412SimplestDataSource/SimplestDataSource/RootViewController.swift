

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
    
    var pep : [String]! = ["Manny", "Moe", "Jack"] // pretend model might not be ready
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // so this is still legal; you can give a tvc a refresh control in iOS 10
        // however, what's new is that this is _actually_ the table's refresh control
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl!.addTarget(self, action: #selector(doRefresh), for: .valueChanged)
//        print(self.tableView!.refreshControl)
        
        // so you can write it like this instead:
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl!.addTarget(self, action: #selector(doRefresh), for: .valueChanged)
        
        // moreover, when you do, your code just keeps on working;
        // this is also still the table view controller's refresh control!
        
        // showing that the refresh control's background color covers the table's background
        let v = UIView()
        v.backgroundColor = .yellow
        self.tableView.backgroundView = v
        self.tableView.refreshControl?.backgroundColor = .green
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
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) 

        cell.textLabel!.text = pep[indexPath.row]
        return cell
    }

    @IBAction func doRefresh(_ sender: AnyObject) {
        print("refreshing...")
        delay(3) {
            (sender as! UIRefreshControl).endRefreshing()
            print("done")
        }
    }

    @IBAction func doRefreshManually(_ sender: AnyObject) {
        // all this talk of `self.refreshControl` works, even though we didn't assign this way
        self.tableView.setContentOffset(
            CGPoint(0, -self.refreshControl!.bounds.height),
            animated:true)
        self.refreshControl!.beginRefreshing()
        self.doRefresh(self.refreshControl!)
    }
}
