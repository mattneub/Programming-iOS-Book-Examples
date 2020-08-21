

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
        super.viewDidLoad()
        let s = try! String(
            contentsOfFile: Bundle.main.path(
                forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        let d = Dictionary(grouping: states) {String($0.prefix(1))}
        self.sections = Array(d).sorted {$0.key < $1.key}.map {
            Section(sectionName: $0.key, rowData: $0.value)
        }
        
        self.tableView.register(MyCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.register(MyHeader.self, forHeaderFooterViewReuseIdentifier: self.headerID)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! MyCell
        let s = self.sections[indexPath.section].rowData[indexPath.row]
        let config = MyCell.Configuration(stateName: s)
        cell.configure(config)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerID) as! MyHeader
        let config = MyHeader.Configuration(sectionName: self.sections[section].sectionName)
        h.configure(config)
        return h
        
    }
        
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sections.map {$0.sectionName}
    }
}
