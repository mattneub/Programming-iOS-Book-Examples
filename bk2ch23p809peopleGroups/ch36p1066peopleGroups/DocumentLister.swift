

import UIKit

class DocumentLister: UITableViewController {
    
    var files = [NSURL]()
    var docsurl : NSURL {
        var url = NSURL()
        let del = UIApplication.sharedApplication().delegate
        if let ubiq = (del as! AppDelegate).ubiq {
            url = ubiq
        } else {
            do {
                let fm = NSFileManager()
                url = try fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            } catch {
                print(error)
            }
        }
        return url
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
        print("refreshing")
        do {
            let fm = NSFileManager()
            self.files = try fm.contentsOfDirectoryAtURL(
                self.docsurl, includingPropertiesForKeys: nil, options: [])
                .filter {
                    print($0)
                    if fm.isUbiquitousItemAtURL($0) {
                        print("trying to download \($0)")
                        try fm.startDownloadingUbiquitousItemAtURL($0)
                    }
                    return $0.pathExtension! == "pplgrp"
            }
            self.tableView.reloadData()
        } catch {
            print(error)
        }
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
            guard let name = av.textFields![0].text where !name.isEmpty else {return}
            let url = self.docsurl.URLByAppendingPathComponent((name as NSString).stringByAppendingPathExtension("pplgrp")!)
            // really should check to see if file by this name exists
            let pl = PeopleLister(fileURL: url)
            self.navigationController!.pushViewController(pl, animated: true)
        })
        self.presentViewController(av, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.doRefresh(nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath)
        let fileURL = self.files[indexPath.row]
        cell.textLabel!.text = (fileURL.lastPathComponent! as NSString).stringByDeletingPathExtension
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let pl = PeopleLister(fileURL: self.files[indexPath.row])
        self.navigationController!.pushViewController(pl, animated: true)
    }

    
}
