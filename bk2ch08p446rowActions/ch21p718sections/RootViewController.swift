
import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



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
        
//        let b = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "doEdit:")
//        self.navigationItem.rightBarButtonItem = b
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem // badda-bing, badda-boom
    }
    
//    func doEdit(_ sender: Any?) {
//        var which : UIBarButtonSystemItem
//        if !self.tableView.editing {
//            self.tableView.setEditing(true, animated:true)
//            which = .Done
//        } else {
//            self.tableView.setEditing(false, animated:true)
//            which = .Edit
//        }
//        let b = UIBarButtonItem(barButtonSystemItem: which, target: self, action: "doEdit:")
//        self.navigationItem.rightBarButtonItem = b
//    }
    
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
            h.backgroundView?.backgroundColor = .black
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

    // removed; we're doing row actions / swipe actions
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt ip: IndexPath) {
//    }
    
    // new iOS 11 feature: at last, we get parity with Mail! here's how:
    
    @available(iOS 11.0, *)
    override func tableView(_ tv: UITableView, leadingSwipeActionsConfigurationForRowAt ip: IndexPath) -> UISwipeActionsConfiguration? {
        // styles are .normal and .destructive
        let m = UIContextualAction(style: .normal, title: "Mark") {
            action, view, completion in
            // parameters are: the contextual action itself;
            // the containing view; this will probably be useless
            // (not cell! we are not in the cell)
            // completion handler, which you must execute
            print(action)
//            var view: UIView = view
//            while !(view is UITableView) { view = view.superview! }
            print(view)
            print("Mark") // in real life, do something here
            print(ip) // this is how you know where we are
            completion(true)
        }
        m.backgroundColor = .blue
        // can add an image instead of a title (title is just nil in that case)
        let config = UISwipeActionsConfiguration(actions: [m])
        config.performsFirstActionWithFullSwipe = true // default is false
        return config
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt ip: IndexPath) -> UISwipeActionsConfiguration? {
        let d = UIContextualAction(style: .normal, title: nil) {
            action, view, completion in
            // exactly the same as delete case of tableView:commit
            print("Delete in swipe action")
            self.sections[ip.section].rowData.remove(at:ip.row)
            tableView.performBatchUpdates({
                tableView.deleteRows(at:[ip], with: .automatic)
            }) {_ in
                if self.sections[ip.section].rowData.count == 0 {
                    self.sections.remove(at:ip.section)
                    tableView.performBatchUpdates ({
                        tableView.deleteSections(
                            IndexSet(integer: ip.section), with:.fade)
                    })
                }
            }
            completion(true)
        }
        d.backgroundColor = .red
        d.image = UIGraphicsImageRenderer(size:CGSize(30,30)).image { _ in
            UIImage(named:"trash")?.draw(in: CGRect(0,0,30,30))
        }
        // .withRenderingMode(.alwaysOriginal) // just an experiment; has no effect
        let m = UIContextualAction(style: .normal, title: "Mark") {
            action, view, completion in
            print("Mark") // in real life, do something here
            completion(true)
        }
        m.backgroundColor = .blue

        let config = UISwipeActionsConfiguration(actions: [d,m])
        config.performsFirstActionWithFullSwipe = false // default is true
        return config
    }
    
    // this is still effective in iOS 11
    override func tableView(_ tv: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let act = UITableViewRowAction(style: .normal, title: "Mark") {
            action, ip in
            print("Mark") // in real life, do something here
            tv.cellForRow(at: ip)?.isEditing = false  // how do I close it up?
        }
        act.backgroundColor = .blue
        let act2 = UITableViewRowAction(style: .default, title: "Delete") {
            action, ip in
            print("Delete in row action")
            tv.beginUpdates()
            self.sections[ip.section].rowData.remove(at:ip.row)
            tv.deleteRows(at:[ip], with:.left)
            if self.sections[ip.section].rowData.count == 0 {
                self.sections.remove(at:ip.section)
                tv.deleteSections(
                    IndexSet(integer: ip.section), with:.right)
            }
            tv.endUpdates()
        }
        if #available(iOS 11.0, *) {
            return [act2] // so that we still have a working Delete button in Edit mode
        }
        return [act2, act]
    }
    
    
}
