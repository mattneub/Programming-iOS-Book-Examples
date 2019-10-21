

import UIKit
import CoreData

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class PeopleLister: UITableViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {
    
    let group : Group
    
    init(group:Group) {
        self.group = group
        super.init(nibName:"PeopleLister", bundle:nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    lazy var ds : UITableViewDiffableDataSource<String,NSManagedObjectID> = {
        UITableViewDiffableDataSource(tableView: self.tableView) {
            tv,ip,id in
            let cell = tv.dequeueReusableCell(withIdentifier: "Person", for: ip)
            let person = self.frc.object(at: ip)
            let first = cell.viewWithTag(1) as! UITextField
            let last = cell.viewWithTag(2) as! UITextField
            first.text = person.firstName; last.text = person.lastName
            first.delegate = self; last.delegate = self
            return cell
        }
    }()
    
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
        
        _ = self.frc // "tickle" the lazies
    }
        
    @objc func doAdd(_:AnyObject) {
        self.tableView.endEditing(true)
        let context = self.frc.managedObjectContext
        let person = Person(context:context)
        person.group = self.group
        person.lastName = ""
        person.firstName = ""
        person.timestamp = Date()
        delay(0.1) {
            let row = self.tableView.numberOfRows(inSection: 0) - 1
            let ip = IndexPath(row: row, section: 0)
            self.tableView.scrollToRow(at: ip, at: .bottom, animated: false)
            let cell = self.tableView.cellForRow(at: ip)
            if let cell = cell {
                if let tf = cell.contentView.viewWithTag(1) as? UITextField {
                    tf.becomeFirstResponder()
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("did end editing")
        var v : UIView = textField
        repeat { v = v.superview! } while !(v is UITableViewCell)
        let cell = v as! UITableViewCell
        let ip = self.tableView.indexPath(for:cell)!
        let object = self.frc.object(at:ip)
        object.setValue(textField.text!, forKey: ((textField.tag == 1) ? "firstName" : "lastName"))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    // === content update ===
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        // it's a string and a NSManagedObjectID
        //        var snap = NSDiffableDataSourceSnapshot<String,NSManagedObjectID>()
        //        snap.appendSections(snapshot.sectionIdentifiers as! [String])
        //        for item in snapshot.itemIdentifiers {
        //            let section = snapshot.sectionIdentifier(forSectionContainingItemIdentifier: item)
        //            snap.appendItems([item as! NSManagedObjectID], toSection: section as? String)
        //        }
        //        self.ds.apply(snap, animatingDifferences: false)
        print("change")
        let oldsnapshot = self.ds.snapshot()
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<String,NSManagedObjectID>
        if oldsnapshot.itemIdentifiers == snapshot.itemIdentifiers {
            return // prevent reload in case where nothing happened
        }
        self.ds.apply(snapshot, animatingDifferences: false)
    }

}
