

import UIKit
import CoreData

class PeopleLister: UITableViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {
    
    let groupObject : NSManagedObject
    lazy var frc : NSFetchedResultsController = {
        let req = NSFetchRequest()
        let entity = NSEntityDescription.entity(forEntityName:"Person", in:self.groupObject.managedObjectContext!)
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
        
        do {
            try afrc.performFetch()
        } catch {
            print("Unresolved error \(error)")
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
        let b = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doAdd))
        self.navigationItem.rightBarButtonItems = [b]
        
        self.tableView.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "Person")
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.frc.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.frc.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Person", for: indexPath)
        let object = self.frc.object(at:indexPath) as! NSManagedObject
        let first = cell.withTag(1) as! UITextField
        let last = cell.withTag(2) as! UITextField
        first.text = object.firstName
        last.text = object.lastName
        first.delegate = self; last.delegate = self
        return cell
    }
    
    func doAdd(_:AnyObject) {
        self.tableView.endEditing(true)
        let context = self.frc.managedObjectContext
        let entity = self.frc.fetchRequest.entity!
        let mo = NSEntityDescription.insertNewObject(forEntityName:entity.name!, into:context)
        mo.group = self.groupObject
        mo.lastName = ""
        mo.firstName = ""
        mo.timestamp = NSDate()
        // save context
        do {
            try context.save()
        } catch {
            print(error)
            return
        }
        // and the rest is in the update delegate messages
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("did end editing")
        var v = textField.superview!
        while !(v is UITableViewCell) {v = v.superview!}
        let cell = v as! UITableViewCell
        let ip = self.tableView.indexPath(for:cell)!
        let object = self.frc.object(at:ip) as! NSManagedObject
        object.setValue(textField.text!, forKey: ((textField.tag == 1) ? "firstName" : "lastName"))
        
        // save context
        do {
            try object.managedObjectContext!.save()
        } catch {
            print(error)
            return
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let context = self.frc.managedObjectContext
        // save context
        do {
            try context.save()
        } catch {
            print(error)
            return
        }
    }
    
    // === content update ===
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController,
        didChange anObject: AnyObject,
        at indexPath: NSIndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            if type == .insert {
                self.tableView.insertRows(at:[newIndexPath!], with: .automatic)
                dispatch_async(dispatch_get_main_queue()) { // wait for interface to settle
                    let cell = self.tableView.cellForRow(at:newIndexPath!)!
                    let tf = cell.withTag(1) as! UITextField
                    tf.becomeFirstResponder()
                }
            }
    }

}
