

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
        
        let bbi = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(doChange))
        self.navigationItem.rightBarButtonItem = bbi
    }
    
    // let's test the real reason we're here! diff that puppy and reload with animation
    @objc func doChange(_ sender:Any) {
        var snap = self.datasource.snapshot()
        if snap.itemIdentifiers.contains(0) {
            snap.deleteItems([0])
            snap.insertItems([100], beforeItem: 1)
        } else {
            snap.deleteItems([100])
            snap.insertItems([0], beforeItem: 1)
        }
        self.datasource.defaultRowAnimation = .fade
        self.datasource.apply(snap, animatingDifferences: true, completion: nil)
        // excellent but then what is `reloadItems` for?
        // how can it ever affect the table view?
    }
    
}
