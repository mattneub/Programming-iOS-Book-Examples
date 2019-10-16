

import UIKit

class MasterViewController: UITableViewController {

    var objects = [NSDate]()


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject))
        self.navigationItem.rightBarButtonItem = addButton
    }


    @objc func insertNewObject(_ sender: Any) {
        objects.insert(Date() as NSDate, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at:[indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let object = objects[indexPath.row]
            (segue.destination as! DetailViewController).detailItem = object
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    /*
    Put a symbolic breakpoint on -[UILabel setFont:]
    You will see that when dynamic type is triggered,
    the table view's layoutSubviews is called;
    this causes the cells to be recreated,
    and so the fonts for the labels are freshly set.
    The table is _always_ listening for the dynamic type notification;
    it doesn't have special knowledge that dynamic type is actually being used.
    */
    
    // in iOS 11 this feature seems badly behaved
    // we do not adopt the correct size on creation / launch, only later when the user changes size

	let cellID = "Cell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) 

        let object = objects[indexPath.row]
        cell.textLabel!.text = object.description
        cell.detailTextLabel!.text = "Detail"
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at:indexPath.row)
            tableView.deleteRows(at:[indexPath], with: .fade)
        }
    }


}

