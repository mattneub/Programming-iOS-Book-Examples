

import UIKit

class MasterViewController: UITableViewController {
    
    let model = ["Manny", "Moe", "Jack"]
    
    let cellID = "Cell"
    
    override init(style: UITableView.Style) {
        super.init(style:style)
        self.edgesForExtendedLayout = .all
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        
        print(self.splitViewController?.children as Any)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel!.text = model[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController()
        detail.boy = model[indexPath.row]
        let b = self.splitViewController?.displayModeButtonItem
        detail.navigationItem.leftBarButtonItem = b
        detail.navigationItem.leftItemsSupplementBackButton = true
        
        let nav = UINavigationController(rootViewController: detail)
        self.showDetailViewController(nav, sender: self)
        
        if let del = self.splitViewController?.delegate as? AppDelegate {
            del.didChooseDetail = true
        }
    }
    
    // ====
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // logging to show that I'm right to describe the detail view controller as "jettisoned".
        // it is not _released_, but that's an internal implementation detail:
        // the split view controller keeps it in its `__preservedDetailController` property
        print(self.splitViewController?.children as Any)
        
    }
    
}
