
import UIKit
import QuickLook

// To get this to work, I did NOT have to make my app owner / editor of this type;
// I guess all it has to do is be an exporter of the type

class PreviewViewController: UITableViewController, QLPreviewingController {
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false // only a preview
    }
    
    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        let doc = PeopleDocument(fileURL:url)
        doc.open { ok in
            if ok {
                self.people = doc.people
                self.tableView.register(
                    UINib(nibName: "PersonCell", bundle: nil),
                    forCellReuseIdentifier: "Person")
                self.tableView.reloadData()
                handler(nil)
            } else {
                handler(NSError(domain: "NoDataDomain", code: -1, userInfo: nil))
            }
        }
        return;
        
        // this code was developed for iOS 11 when doc.open was failing, but in iOS 12 it works
        let fc = NSFileCoordinator()
        let intent = NSFileAccessIntent.readingIntent(with: url)
        let queue = OperationQueue()
        fc.coordinate(with: [intent], queue: queue) { err in
            do {
                let data = try Data(contentsOf: intent.url)
                let doc = PeopleDocument(fileURL: url)
                try doc.load(fromContents: data, ofType: nil)
                self.people = doc.people
                DispatchQueue.main.async {
                    self.tableView.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "Person")
                    self.tableView.reloadData()
                }
                handler(nil)
            } catch {
                handler(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Person", for: indexPath)
        let first = cell.viewWithTag(1) as! UITextField
        let last = cell.viewWithTag(2) as! UITextField
        let p = self.people[indexPath.row]
        first.text = p.firstName
        last.text = p.lastName
        first.isEnabled = false // only a preview
        last.isEnabled = false // only a preview
        return cell
    }

}
