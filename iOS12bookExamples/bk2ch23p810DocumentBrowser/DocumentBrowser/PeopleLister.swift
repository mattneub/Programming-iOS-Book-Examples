

import UIKit

class PeopleLister: UITableViewController, UITextFieldDelegate {
    
    let fileURL : URL
    var doc : PeopleDocument!
    var people : [Person] { // point to the document's model object
        get { return self.doc.people }
        set { self.doc.people = newValue }
    }

    init(fileURL:URL) {
        self.fileURL = fileURL
        super.init(nibName: "PeopleLister", bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = (self.fileURL.lastPathComponent as NSString)
            .deletingPathExtension
        let b = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doAdd))
        self.navigationItem.rightBarButtonItems = [b]
        // we are now a presented view controller, so we also need a way to dismiss
        let b2 = UIBarButtonItem(title: "Done", style:.done, target: self, action: #selector(doDone))
        self.navigationItem.leftBarButtonItems = [b2]

        
        self.tableView.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "Person")
        
        let fm = FileManager.default
        self.doc = PeopleDocument(fileURL:self.fileURL)
        
        func listPeople(_ success:Bool) {
            if success {
                // self.people = self.doc.people as NSArray as [Person]
                self.tableView.reloadData()
            }
        }
        if let _ = try? self.fileURL.checkResourceIsReachable() {
            self.doc.open(completionHandler:listPeople)
        } else {
            self.doc.save(to:self.doc.fileURL,
                          for: .forCreating,
                          completionHandler: listPeople)
        }
    }
    
    @objc func doAdd (_ sender: Any) {
        self.tableView.endEditing(true)
        let newP = Person(firstName: "", lastName: "")
        self.people.append(newP)
        let ct = self.people.count
        let ix = IndexPath(row:ct-1, section:0)
        self.tableView.reloadData()
        self.tableView.scrollToRow(at:ix, at:.bottom, animated:true)
        let cell = self.tableView.cellForRow(at:ix)!
        let tf = cell.viewWithTag(1) as! UITextField
        tf.becomeFirstResponder()
        
        self.doc.updateChangeCount(.done)
    }
    
    @objc func doDone (_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true) {
            self.doc?.close(completionHandler: nil)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.doc == nil {
            print("doc was nil")
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("self.people was \(self.people)")
        return self.people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Person", for: indexPath)
        let first = cell.viewWithTag(1) as! UITextField
        let last = cell.viewWithTag(2) as! UITextField
        let p = self.people[indexPath.row]
        first.text = p.firstName
        last.text = p.lastName
        first.delegate = self
        last.delegate = self
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("did end editing")
        var v = textField.superview!
        while !(v is UITableViewCell) {v = v.superview!}
        let cell = v as! UITableViewCell
        let ip = self.tableView.indexPath(for:cell)!
        let row = ip.row
        let p = self.people[row]
        let which = textField.tag == 1 ? \Person.firstName : \.lastName
        p[keyPath:which] = textField.text!

        self.doc.updateChangeCount(.done)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tableView.endEditing(true)
        self.people.remove(at:indexPath.row)
        tableView.deleteRows(at:[indexPath], with:.automatic)
        
        self.doc.updateChangeCount(.done)
    }
    
    @objc func forceSave(_: Any?) {
        print("force save")
        self.tableView.endEditing(true)
        self.doc.save(to:self.doc.fileURL, for:.forOverwriting)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(forceSave), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.forceSave(nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
