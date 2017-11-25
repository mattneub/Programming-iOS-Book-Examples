
import UIKit
import CoreData

class GroupLister: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext : NSManagedObjectContext!
    
    lazy var frc: NSFetchedResultsController<Group> = {
        let req: NSFetchRequest<Group> = Group.fetchRequest()
        req.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key:"timestamp", ascending:true)
        req.sortDescriptors = [sortDescriptor]

        let afrc = NSFetchedResultsController(
            fetchRequest:req,
            managedObjectContext:self.managedObjectContext,
            sectionNameKeyPath:nil, cacheName:nil)
        afrc.delegate = self
        do {
            try afrc.performFetch()
        } catch {
            print("Unresolved error \(error)")
            fatalError("Aborting with unresolved error")
        }
        return afrc
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        let b = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doAdd))
        self.navigationItem.rightBarButtonItems = [b]
        let b2 = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(doRefresh))
        self.navigationItem.leftBarButtonItems = [b2]
        self.title = "Groups"
        // no need to register cell, comes from storyboard
    }
    
    func doRefresh(_:AnyObject) {
        // currently a no-op
    }
    
    func doAdd(_:AnyObject) {
        let av = UIAlertController(title: "New Group", message: "Enter name:", preferredStyle: .alert)
        av.addTextField {$0.autocapitalizationType = .words}
        av.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        av.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let name = av.textFields![0].text, !name.isEmpty else {return}
            let context = self.frc.managedObjectContext
            let group = Group(context: context)
            group.name = name
            group.uuid = NSUUID().uuidString
            group.timestamp = NSDate()
            
            // save context
            do {
                try context.save()
            } catch {
                print(error)
                return
            }
            let pl = PeopleLister(group: group)
            self.navigationController!.pushViewController(pl, animated: true)
            })
        self.present(av, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.frc.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.frc.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let group = self.frc.object(at:indexPath)
        cell.textLabel!.text = group.name
        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pl = PeopleLister(group: self.frc.object(at:indexPath))
        self.navigationController!.pushViewController(pl, animated: true)
    }
 

}
