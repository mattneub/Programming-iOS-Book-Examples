

import UIKit
import CoreData

class PeopleLister: UITableViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {
    
    let group : Group

    init(group:Group) {
        self.group = group
        super.init(nibName:"PeopleLister", bundle:nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    lazy var frc: NSFetchedResultsController<Person> = {
        let req: NSFetchRequest<Person> = Person.fetchRequest()
        req.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key:"timestamp", ascending:true)
        req.sortDescriptors = [sortDescriptor]

        let pred = NSPredicate(format:"group = %@", self.group)
        req.predicate = pred
        
        let afrc = NSFetchedResultsController(fetchRequest:req,
            managedObjectContext:self.group.managedObjectContext!,
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
        
        self.title = self.group.name
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Person", for: indexPath)
        let person = self.frc.object(at:indexPath)
        let first = cell.viewWithTag(1) as! UITextField
        let last = cell.viewWithTag(2) as! UITextField
        first.text = person.firstName; last.text = person.lastName
        first.delegate = self; last.delegate = self
        return cell
    }
    
    @objc func doAdd(_:AnyObject) {
        self.tableView.endEditing(true)
        let context = self.frc.managedObjectContext
        let person = Person(context:context)
        person.group = self.group
        person.lastName = ""
        person.firstName = ""
        person.timestamp = Date()
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
        var v : UIView = textField
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! UITableViewCell
        let ip = self.tableView.indexPath(for:cell)!
        let object = self.frc.object(at:ip)
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
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
            if type == .insert {
                self.tableView.insertRows(at:[newIndexPath!], with: .automatic)
                DispatchQueue.main.async { // wait for interface to settle
                    let cell = self.tableView.cellForRow(at:newIndexPath!)!
                    let tf = cell.viewWithTag(1) as! UITextField
                    tf.becomeFirstResponder()
                }
            }
    }

}
