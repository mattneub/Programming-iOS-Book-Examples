

import UIKit

class GroupLister: UITableViewController {
    
    var files = [URL]()
    var docsurl : URL {
        let del = UIApplication.shared.delegate
        if let ubiq = (del as! AppDelegate).ubiq {
            return ubiq
        } else {
            do {
                let fm = FileManager.default
                return try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            } catch {
                print(error)
            }
        }
        return NSURL() as URL // shouldn't happen
    }
    
	let cellID = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let b = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doAdd))
        self.navigationItem.rightBarButtonItems = [b]
        let b2 = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(doRefresh))
        self.navigationItem.leftBarButtonItems = [b2]
        self.title = "Groups"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        
    }
    
    @objc func doRefresh (_: Any?) {
        print("refreshing")
        do {
            let fm = FileManager.default
            self.files = try fm.contentsOfDirectory(at: self.docsurl, includingPropertiesForKeys: nil).filter {
                    print($0)
                    if fm.isUbiquitousItem(at:$0) {
                        print("trying to download \($0)")
                        try fm.startDownloadingUbiquitousItem(at:$0)
                    }
                    return $0.pathExtension == "pplgrp"
            }
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    @objc func doAdd (_: Any?) {
        let av = UIAlertController(title: "New Group", message: "Enter name:", preferredStyle: .alert)
        av.addTextField {$0.autocapitalizationType = .words}
        av.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        av.addAction(UIAlertAction(title: "OK", style: .default) {
            _ in
            guard let name = av.textFields![0].text, !name.isEmpty else {return}
            let url = self.docsurl.appendingPathComponent((name as NSString).appendingPathExtension("pplgrp")!)
            // really should check to see if file by this name exists
            let pl = PeopleLister(fileURL: url)
            self.navigationController!.pushViewController(pl, animated: true)
        })
        self.present(av, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.doRefresh(nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let fileURL = self.files[indexPath.row]
        cell.textLabel!.text = (fileURL.lastPathComponent as NSString).deletingPathExtension
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pl = PeopleLister(fileURL: self.files[indexPath.row])
        self.navigationController!.pushViewController(pl, animated: true)
    }

    
}
