

import UIKit

class MasterViewController: UITableViewController {
    
    let model = ["Manny", "Moe", "Jack"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        print(self.splitViewController?.childViewControllers)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) 
        cell.textLabel!.text = model[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController()
        detail.boy = model[indexPath.row]
        let b = self.splitViewController?.displayModeButtonItem()
        detail.navigationItem.leftBarButtonItem = b
        detail.navigationItem.leftItemsSupplementBackButton = true
        
        let nav = UINavigationController(rootViewController: detail)
        self.showDetailViewController(nav, sender: self)
        
        let del = UIApplication.shared().delegate as! AppDelegate
        del.didChooseDetail = true
    }
    
    // ====
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // logging to show that I'm right to describe the detail view controller as "jettisoned".
        // it is not _released_, but that's an internal implementation detail:
        // the split view controller keeps it in its `__preservedDetailController` property
        print(self.splitViewController?.childViewControllers)
        
    }
    
}
