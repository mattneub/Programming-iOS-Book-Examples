

import UIKit

class PeopleLister: UITableViewController, UITextFieldDelegate {
    
    let fileURL : NSURL
    var doc : PeopleDocument!
    var people : [Person] { // front end for the document's model object
        get {
            return self.doc.people
        }
        set (val) {
            self.doc.people = val
        }
    }

    init(fileURL:NSURL) {
        self.fileURL = fileURL
        super.init(nibName: "PeopleLister", bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = (self.fileURL.lastPathComponent! as NSString).stringByDeletingPathExtension
        let b = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "doAdd:")
        self.navigationItem.rightBarButtonItems = [b]
        
        self.tableView.registerNib(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "Person")
        
        let fm = NSFileManager()
        self.doc = PeopleDocument(fileURL:self.fileURL)
        
        func listPeople(success:Bool) {
            if success {
                // self.people = self.doc.people as NSArray as [Person]
                self.tableView.reloadData()
            }
        }
        if !fm.fileExistsAtPath(self.fileURL.path!) {
            self.doc.saveToURL(self.doc.fileURL,
                forSaveOperation: .ForCreating,
                completionHandler: listPeople)
        } else {
            self.doc.openWithCompletionHandler(listPeople)
        }
    }
    
    func doAdd (sender:AnyObject) {
        self.tableView.endEditing(true)
        let newP = Person(firstName: "", lastName: "")
        self.people.append(newP)
        let ct = self.people.count
        let ix = NSIndexPath(forRow:ct-1, inSection:0)
        self.tableView.reloadData()
        self.tableView.scrollToRowAtIndexPath(ix, atScrollPosition:.Bottom, animated:true)
        let cell = self.tableView.cellForRowAtIndexPath(ix)!
        let tf = cell.viewWithTag(1) as! UITextField
        tf.becomeFirstResponder()
        
        self.doc.updateChangeCount(.Done)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.doc == nil {
            print("doc was nil")
            return 0
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("self.people was \(self.people)")
        return self.people.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Person", forIndexPath:indexPath)
        let first = cell.viewWithTag(1) as! UITextField
        let last = cell.viewWithTag(2) as! UITextField
        let p = self.people[indexPath.row]
        first.text = p.firstName
        last.text = p.lastName
        first.delegate = self
        last.delegate = self
        return cell
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("did end editing")
        var v = textField.superview!
        while !(v is UITableViewCell) {v = v.superview!}
        let cell = v as! UITableViewCell
        let ip = self.tableView.indexPathForCell(cell)!
        let row = ip.row
        let p = self.people[row]
        p.setValue(textField.text, forKey: textField.tag == 1 ? "firstName" : "lastName")
        
        self.doc.updateChangeCount(.Done)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.endEditing(true)
        self.people.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
        
        self.doc.updateChangeCount(.Done)
    }
    
    func forceSave(_:AnyObject?) {
        print("force save")
        self.tableView.endEditing(true)
        self.doc.saveToURL(self.doc.fileURL, forSaveOperation:.ForOverwriting, completionHandler:nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "forceSave:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.forceSave(nil)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
