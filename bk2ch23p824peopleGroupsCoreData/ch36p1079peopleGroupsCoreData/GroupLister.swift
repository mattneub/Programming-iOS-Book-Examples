
import UIKit
import CoreData

class GroupLister: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext : NSManagedObjectContext!
    lazy var frc : NSFetchedResultsController = {
        let req = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Group", inManagedObjectContext:self.managedObjectContext)
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

        let b = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "doAdd:")
        self.navigationItem.rightBarButtonItems = [b]
        let b2 = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "doRefresh:")
        self.navigationItem.leftBarButtonItems = [b2]
        self.title = "Groups"
        // no need to register cell, comes from storyboard
    }
    
    func doRefresh(_:AnyObject) {
        // currently a no-op
    }
    
    func doAdd(_:AnyObject) {
        let av = UIAlertController(title: "New Group", message: "Enter name:", preferredStyle: .Alert)
        av.addTextFieldWithConfigurationHandler {
            tf in
            tf.autocapitalizationType = .Words
        }
        av.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        av.addAction(UIAlertAction(title: "OK", style: .Default) {
            _ in
            guard let name = av.textFields![0].text where !name.isEmpty else {return}
            let context = self.frc.managedObjectContext
            let entity = self.frc.fetchRequest.entity!
            let mo = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
            mo.name = name
            mo.uuid = NSUUID().UUIDString
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
        self.presentViewController(av, animated: true, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.frc.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.frc.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)
        cell.accessoryType = .DisclosureIndicator
        let object = self.frc.objectAtIndexPath(indexPath) as! NSManagedObject
        cell.textLabel!.text = object.name
        return cell
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let pl = PeopleLister(groupManagedObject: self.frc.objectAtIndexPath(indexPath) as! NSManagedObject)
        self.navigationController!.pushViewController(pl, animated: true)
    }

}
