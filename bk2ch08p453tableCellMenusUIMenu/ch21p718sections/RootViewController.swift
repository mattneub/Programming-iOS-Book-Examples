

import UIKit

class RootViewController : UITableViewController {
    struct Section {
        var sectionName : String
        var rowData : [String]
    }
    var sections : [Section]!

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    let cellID = "Cell"
	let headerID = "Header"

    override func viewDidLoad() {
        let s = try! String(
            contentsOfFile: Bundle.main.path(
                forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        let d = Dictionary(grouping: states) {String($0.prefix(1))}
        self.sections = Array(d).sorted{$0.key < $1.key}.map {
            Section(sectionName: $0.key, rowData: $0.value)
        }

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: self.headerID)
        
        self.tableView.sectionIndexColor = .white
        self.tableView.sectionIndexBackgroundColor = .red
        self.tableView.sectionIndexTrackingBackgroundColor = .blue
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rowData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let s = self.sections[indexPath.section].rowData[indexPath.row]
        cell.textLabel!.text = s
        
        // this part is not in the book, it's just for fun
        var stateName = s
        stateName = stateName.lowercased()
        stateName = stateName.replacingOccurrences(of:" ", with:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        cell.imageView!.image = im
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: self.headerID)!
        if h.viewWithTag(1) == nil {
            
            h.backgroundView = UIView()
            h.backgroundView?.backgroundColor = .lightGray // make it easier to see menu
            let lab = UILabel()
            lab.tag = 1
            lab.font = UIFont(name:"Georgia-Bold", size:22)
            lab.textColor = .green
            lab.backgroundColor = .clear
            h.contentView.addSubview(lab)
            let v = UIImageView()
            v.tag = 2
            v.backgroundColor = .black
            v.image = UIImage(named:"us_flag_small.gif")
            h.contentView.addSubview(v)
            lab.translatesAutoresizingMaskIntoConstraints = false
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:
                    "H:|-5-[lab(25)]-10-[v(40)]",
                    metrics:nil, views:["v":v, "lab":lab]),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:|[v]|",
                    metrics:nil, views:["v":v]),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:|[lab]|",
                    metrics:nil, views:["lab":lab])
                ].flatMap{$0})
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.sections[section].sectionName
        return h
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sections.map{$0.sectionName}
    }
    
    // menu handling ==========
    
    /*
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    let copy = #selector(UIResponderStandardEditActions.copy)
    
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == copy
    }
    
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == copy {
            // ... do whatever copying consists of ...
            print("copying \(self.sections[indexPath.section].rowData[indexPath.row])")
        }
    }
 */
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt ip: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let cell = tableView.cellForRow(at: ip)!
        let pt2 = cell.convert(point, from: tableView)
        let copyImage = cell.imageView!.frame.contains(pt2)
        
        let d : NSDictionary = ["isImage":copyImage, "indexPath":ip]

        let config = UIContextMenuConfiguration(identifier:d, previewProvider: nil) { _ in
            let action = UIAction(title: "Copy") { _ in
                let state = self.sections[ip.section].rowData[ip.row]
                if copyImage {
                    UIPasteboard.general.image = cell.imageView!.image
                } else {
                    UIPasteboard.general.string = state
                }
            }
            let menu = UIMenu(title: "", children: [action])
            return menu
        }
        return config
    }

    override func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration config: UIContextMenuConfiguration) -> UITargetedPreview? {
        if let d = config.identifier as? [String:Any] {
            if let ip = d["indexPath"] as? IndexPath,
                let ok = d["isImage"] as? Bool, ok {
                    let cell = tableView.cellForRow(at: ip)!
                    return UITargetedPreview(view:cell.imageView!)
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration config: UIContextMenuConfiguration) -> UITargetedPreview? {
        if let d = config.identifier as? [String:Any] {
            if let ip = d["indexPath"] as? IndexPath,
                let ok = d["isImage"] as? Bool, ok {
                    let cell = tableView.cellForRow(at: ip)!
                    return UITargetedPreview(view:cell.imageView!)
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            let vc = UIViewController()
            vc.loadViewIfNeeded()
            vc.view.backgroundColor = .yellow
            let lab = UILabel(frame:CGRect(x: 50, y: 50, width: 50, height: 50))
            lab.text = "It works!"
            lab.sizeToFit()
            vc.view.addSubview(lab)
            self.show(vc, sender:self)
        }
    }

}
