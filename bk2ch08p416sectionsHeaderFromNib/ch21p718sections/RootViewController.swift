

import UIKit


class MyHeaderView : UITableViewHeaderFooterView {
    weak var content : MyHeaderViewContent!
}

class MyHeaderViewContent : UIView {
    @IBOutlet weak var lab : UILabel!
    @IBOutlet weak var im : UIImageView!

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
        super.viewDidLoad()
        let s = try! String(
            contentsOfFile: Bundle.main.path(
                forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        let d = Dictionary(grouping: states) {String($0.prefix(1))}
        self.sections = Array(d).sorted{$0.key < $1.key}.map {
            Section(sectionName: $0.key, rowData: $0.value)
        }
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.register(MyHeaderView.self, forHeaderFooterViewReuseIdentifier: self.headerID)
        
        self.tableView.sectionIndexColor = .white
        self.tableView.sectionIndexBackgroundColor = .red
        self.tableView.sectionIndexTrackingBackgroundColor = .blue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        stateName = stateName.replacingOccurrences(of: " ", with:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        cell.imageView!.image = im
        
        return cell
    }
    
    // showing how to design a header view in a nib
    // you have to design a content view and stuff it manually into the header view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerID) as! MyHeaderView
        if h.content == nil {
            print("configuring a new header view") // only called about 8 times
            let v = UINib(nibName: "MyHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MyHeaderViewContent
            h.contentView.addSubview(v)
            v.translatesAutoresizingMaskIntoConstraints = false
            v.topAnchor.constraint(equalTo: h.contentView.topAnchor).isActive = true
            v.bottomAnchor.constraint(equalTo: h.contentView.bottomAnchor).isActive = true
            v.leadingAnchor.constraint(equalTo: h.contentView.leadingAnchor).isActive = true
            v.trailingAnchor.constraint(equalTo: h.contentView.trailingAnchor).isActive = true
            h.backgroundView = UIView()
            h.backgroundView?.backgroundColor = .black
            v.backgroundColor = .clear
            h.content = v
        }
        h.content.lab.text = self.sections[section].sectionName
        return h
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // return 0
        return 22
        // return UITableViewAutomaticDimension
    }
    
    /*
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    print(view) // prove we are reusing header views
    }
    */
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // return nil
        return self.sections.map{$0.sectionName}
    }
}
