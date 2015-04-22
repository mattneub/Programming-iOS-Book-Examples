

import UIKit

class PeopleLister: UITableViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {
    
    let groupObject : NSManagedObject
    lazy var frc : NSFetchedResultsController = {
        let req = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext:self.groupObject.managedObjectContext!)
        req.entity = entity
        req.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key:"timestamp", ascending:true)
        req.sortDescriptors = [sortDescriptor]
        let pred = NSPredicate(format:"group = %@", self.groupObject)
        req.predicate = pred
        
        let afrc = NSFetchedResultsController(fetchRequest:req,
            managedObjectContext:self.groupObject.managedObjectContext!,
            sectionNameKeyPath:nil,
            cacheName:self.groupObject.uuid) // prevent cache name conflicts
        afrc.delegate = self
        
        var error : NSError? = nil
        if !afrc.performFetch(&error) {
            println("Unresolved error \(error!) \(error!.userInfo)")
            fatalError("Aborting with unresolved error")
        }
        return afrc
    }()

    init(groupManagedObject:NSManagedObject) {
        self.groupObject = groupManagedObject
        super.init(nibName:"PeopleLister", bundle:nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.groupObject.name
        let b = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "doAdd:")
        self.navigationItem.rightBarButtonItems = [b]
        
        self.tableView.registerNib(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "Person")
    }
        
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.frc.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.frc.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Person", forIndexPath:indexPath) as! UITableViewCell
        let object = self.frc.objectAtIndexPath(indexPath) as! NSManagedObject
        let first = cell.viewWithTag(1) as! UITextField
        let last = cell.viewWithTag(2) as! UITextField
        first.text = object.firstName
        last.text = object.lastName
        first.delegate = self; last.delegate = self
        return cell
    }
    
    func doAdd(_:AnyObject) {
        self.tableView.endEditing(true)
        let context = self.frc.managedObjectContext
        let entity = self.frc.fetchRequest.entity!
        let mo = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext:context) as! NSManagedObject
        mo.group = self.groupObject
        mo.lastName = ""
        mo.firstName = ""
        mo.timestamp = NSDate()
        // save context
        var error : NSError? = nil
        let ok = context.save(&error)
        if !ok {
            println(error!)
            return
        }
        // and the rest is in the update delegate messages
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        println("did end editing")
        var v = textField.superview!
        while !(v is UITableViewCell) {v = v.superview!}
        let cell = v as! UITableViewCell
        let ip = self.tableView.indexPathForCell(cell)!
        let object = self.frc.objectAtIndexPath(ip) as! NSManagedObject
        object.setValue(textField.text, forKey: ((textField.tag == 1) ? "firstName" : "lastName"))
        
        // save context
        var error : NSError? = nil
        let ok = object.managedObjectContext!.save(&error)
        if !ok {
            println(error!)
            return
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let context = self.frc.managedObjectContext
        // save context
        var error : NSError? = nil
        let ok = context.save(&error)
        if !ok {
            println(error!)
            return
        }
    }
    
    // === content update ===
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            if type == .Insert {
                self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
                dispatch_async(dispatch_get_main_queue()) { // wait for interface to settle
                    let cell = self.tableView.cellForRowAtIndexPath(newIndexPath!)!
                    let tf = cell.viewWithTag(1) as! UITextField
                    tf.becomeFirstResponder()
                }
            }
    }

}
