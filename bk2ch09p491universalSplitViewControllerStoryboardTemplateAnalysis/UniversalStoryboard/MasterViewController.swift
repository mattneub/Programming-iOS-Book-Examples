
import UIKit

class MasterViewController: UITableViewController {
    
    // pure template code, except I shortened some names, made it more swifty
    // I've added some comments and logging
    
    // var detail: DetailViewController? = nil
    var objects = [Date]()
    
    override var prefersStatusBarHidden : Bool {
        return true // no effect
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.clearsSelectionOnViewWillAppear = false
            // not sure what this next line does, if anything
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject))
        self.navigationItem.rightBarButtonItem = addButton
        // these next lines do not actually do anything, 
        // so I've taken them out as they are just confusing
        // obviously, though, if we were not using a storyboard and segue we would need them
        // in order to know how to transition to the next view controller
//        if let split = self.splitViewController {
//            let vcs = split.viewControllers
//            self.detail = vcs[vcs.count-1].topViewController as? DetailViewController
//            print("self.detail:")
//            print(self.detail)
//        }
    }
    
    @objc func insertNewObject(_ sender: Any) {
        objects.insert(Date(), at: 0)
        let ip = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at:[ip], with: .automatic)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let ip = self.tableView.indexPathForSelectedRow!
            let object = objects[ip.row]
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            print("prepare for segue")
            print("object: \(object)")
            controller.detailItem = object as AnyObject
            // again, duplication from AppDelegate
            // the problem is that if we do this segue...
            // the detail view navigation controller is completely replaced,
            // so we must re-add the button
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true

        }
    }

    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    let cellID = "Cell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let object = objects[indexPath.row] as NSDate
        cell.textLabel!.text = object.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at:indexPath.row)
            tableView.deleteRows(at:[indexPath], with: .fade)
        }
    }
}

extension MasterViewController {
    override func collapseSecondaryViewController(_ secondaryViewController: UIViewController, for splitViewController: UISplitViewController) {
        print("master view controller collapse")
        super.collapseSecondaryViewController(secondaryViewController, for: splitViewController)
    }
    
    override func targetViewController(forAction action: Selector, sender: Any?) -> UIViewController? {
        print("master view controller target for \(action) \(sender as Any)...")
        let result = super.targetViewController(forAction: action, sender: sender)
        print("master view controller target for \(action), returning \(result as Any)")
        return result
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        print("master view controller showViewController")
        super.show(vc, sender: sender)
    }
    
    // NB it turns out it's important NOT to implement showDetailViewController here at all!
    // if we do, targetViewControllerForAction will return this vc, which is wrong
    // and we'll get an endless cycle.
    // The whole point of targetViewControllerForAction here is that we want it to find
    // the split view controller
    
    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        print("master view controller showDetailViewController")
        super.showDetailViewController(vc, sender: sender)
    }
    
    override func responds(to aSelector: Selector) -> Bool {
        let ok = super.responds(to:aSelector)
        if aSelector == #selector(showDetailViewController) {
            print("master responds? \(ok)")
        }
        return ok
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        var ok = super.canPerformAction(action, withSender:sender)
        if action == #selector(showDetailViewController) {
            ok = false
            print("master can perform? \(ok)")
        }
        return ok
    }
    
    
        
}

