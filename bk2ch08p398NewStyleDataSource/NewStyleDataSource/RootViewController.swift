

import UIKit

class RootViewController: UITableViewController {
    
    enum Section {
        case only
    }
    
    var datasource : UITableViewDiffableDataSource<Section,Int>!
    let cellID = "Cell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        let ds = UITableViewDiffableDataSource<Section,Int>(tableView: self.tableView!) { tv, ip, id in
            let cell = tv.dequeueReusableCell(withIdentifier: self.cellID, for: ip)
            cell.textLabel!.text = "Hello there! \(id)"
            return cell
        }
        var snap = NSDiffableDataSourceSnapshot<Section,Int>()
        snap.appendSections([.only])
        snap.appendItems(Array(0..<20))
        ds.apply(snap, animatingDifferences: false)
        self.datasource = ds
    }
    
    
}
