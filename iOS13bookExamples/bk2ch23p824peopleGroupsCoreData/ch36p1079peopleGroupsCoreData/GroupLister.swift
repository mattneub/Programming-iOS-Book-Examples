
import UIKit
import CoreData

class GroupLister: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext : NSManagedObjectContext!
    
    let cellID = "Cell"
    
    lazy var ds : UITableViewDiffableDataSource<String,NSManagedObjectID> = {
        UITableViewDiffableDataSource(tableView: self.tableView) {
            tv,ip,id in
            let cell = tv.dequeueReusableCell(withIdentifier: self.cellID, for: ip)
            cell.accessoryType = .disclosureIndicator
            let group = self.frc.object(at: ip)
            cell.textLabel!.text = group.name
            return cell
        }
    }()
    
    lazy var frc: NSFetchedResultsController<Group> = {
        let req: NSFetchRequest<Group> = Group.fetchRequest()
        req.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key:"timestamp", ascending:true)
        req.sortDescriptors = [sortDescriptor]

        let frc = NSFetchedResultsController(
            fetchRequest:req,
            managedObjectContext:self.managedObjectContext,
            sectionNameKeyPath:nil, cacheName:nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Unresolved error \(error)")
            fatalError("Aborting with unresolved error")
        }
        return frc
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        let b = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doAdd))
        self.navigationItem.rightBarButtonItems = [b]
        let b2 = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(doRefresh))
        self.navigationItem.leftBarButtonItems = [b2]
        self.title = "Groups"
        // no need to register cell, comes from storyboard
        let _ = self.frc // "tickle" the lazy vars
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    @objc func doRefresh(_:AnyObject) {
        // currently a no-op
    }
    
    @objc func doAdd(_:AnyObject) {
        let av = UIAlertController(title: "New Group", message: "Enter name:", preferredStyle: .alert)
        av.addTextField {$0.autocapitalizationType = .words}
        av.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        av.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // guard let name = av.textFields![0].text, !name.isEmpty else {return}
            let context = self.frc.managedObjectContext
            let group = Group(context: context)
            group.name = av.textFields![0].text!
            group.uuid = UUID()
            group.timestamp = Date()
            let pl = PeopleLister(group: group)
            self.navigationController!.pushViewController(pl, animated: true)
            })
        self.present(av, animated: true)
    }
        
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
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<String,NSManagedObjectID>
        self.ds.apply(snapshot, animatingDifferences: false)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pl = PeopleLister(group: self.frc.object(at:indexPath))
        self.navigationController!.pushViewController(pl, animated: true)
    }
 

}
