

import UIKit

class DocumentLister: UITableViewController {
    
    var files = [NSURL]()
    var docsurl : NSURL {
        get {
            let del = UIApplication.sharedApplication().delegate
            if let ubiq = (del as! AppDelegate).ubiq {
                return ubiq
            } else {
                let fm = NSFileManager()
                return fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil)!
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let b = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "doAdd:")
        self.navigationItem.rightBarButtonItems = [b]
        let b2 = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "doRefresh:")
        self.navigationItem.leftBarButtonItems = [b2]
        self.title = "Groups"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    func doRefresh (_:AnyObject?) {
        let fm = NSFileManager()
        self.files = fm.contentsOfDirectoryAtURL(
            self.docsurl, includingPropertiesForKeys: nil, options: nil, error: nil)!
            .filter
            { ($0 as! NSURL).pathExtension == "pplgrp" } as! [NSURL]
        self.tableView.reloadData()
    }
    
    func doAdd (_:AnyObject?) {
        let av = UIAlertController(title: "New Group", message: "Enter name:", preferredStyle: .Alert)
        av.addTextFieldWithConfigurationHandler {
            tf in
            tf.autocapitalizationType = .Words
        }
        av.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        av.addAction(UIAlertAction(title: "OK", style: .Default) {
            _ in
            let name = (av.textFields![0] as! UITextField).text
            if name == nil || name == "" {return}
            // why on earth is this an optional?? seems like a bug to me
            let url = self.docsurl.URLByAppendingPathComponent(name.stringByAppendingPathExtension("pplgrp")!)
            // really should check to see if file by this name exists
            let pl = PeopleLister(fileURL: url)
            self.navigationController!.pushViewController(pl, animated: true)
        })
        self.presentViewController(av, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.doRefresh(nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as! UITableViewCell
        let fileURL = self.files[indexPath.row]
        cell.textLabel!.text = fileURL.lastPathComponent!.stringByDeletingPathExtension
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let pl = PeopleLister(fileURL: self.files[indexPath.row])
        self.navigationController!.pushViewController(pl, animated: true)
    }

    
}
