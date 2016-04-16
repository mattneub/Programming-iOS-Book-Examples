
import UIKit
import CoreData

class GroupLister: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext : NSManagedObjectContext!
    lazy var frc : NSFetchedResultsController = {
        let req = NSFetchRequest()
        let entity = NSEntityDescription.entity(forEntityName:"Group", in:self.managedObjectContext)
        req.entity = entity
        req.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key:"timestamp", ascending:true)
        req.sortDescriptors = [sortDescriptor]
        
        let afrc = NSFetchedResultsController(fetchRequest:req,
            managedObjectContext:self.managedObjectContext,
            sectionNameKeyPath:nil,
            cacheName:"Groups")
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
        av.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        av.addAction(UIAlertAction(title: "OK", style: .default) {
            _ in
            guard let name = av.textFields![0].text where !name.isEmpty else {return}
            let context = self.frc.managedObjectContext
            let entity = self.frc.fetchRequest.entity!
            let mo = NSEntityDescription.insertNewObject(forEntityName:entity.name!, into: context)
            mo.name = name
            mo.uuid = NSUUID().uuidString
            mo.timestamp = NSDate()
            
            // save context
            do {
                try context.save()
            } catch {
                print(error)
                return
            }
            let pl = PeopleLister(groupManagedObject: mo)
            self.navigationController!.pushViewController(pl, animated: true)
            })
        self.present(av, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.frc.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.frc.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let object = self.frc.object(at:indexPath) as! NSManagedObject
        cell.textLabel!.text = object.name
        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        let pl = PeopleLister(groupManagedObject: self.frc.object(at:indexPath) as! NSManagedObject)
        self.navigationController!.pushViewController(pl, animated: true)
    }

}
