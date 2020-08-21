
import UIKit

// move everything into the data source object!

class MyDataSource: UITableViewDiffableDataSource<String, String> {
    let cellID = "Cell"
    let headerID = "Header"
    init(tableView: UITableView) {
        // table view configuration
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: self.headerID)
        tableView.sectionIndexColor = .white
        tableView.sectionIndexBackgroundColor = .red
        tableView.sectionIndexTrackingBackgroundColor = .blue
        let cellID = self.cellID
        super.init(tableView: tableView) { tv,ip,s in
            let cell = tv.dequeueReusableCell(withIdentifier: cellID, for: ip)
            cell.textLabel!.text = s
            
            var stateName = s
            stateName = stateName.lowercased()
            stateName = stateName.replacingOccurrences(of: " ", with:"")
            stateName = "flag_\(stateName).gif"
            let im = UIImage(named: stateName)
            cell.imageView!.image = im
            
            return cell
        }
        self.populate()
    }
    private func populate() {
        let s = try! String(
            contentsOfFile: Bundle.main.path(
                forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        let d = Dictionary(grouping: states) {String($0.prefix(1))}
        let sections = Array(d).sorted {$0.key < $1.key} // *
        
        var snap = NSDiffableDataSourceSnapshot<String,String>()
        for section in sections {
            snap.appendSections([section.0])
            snap.appendItems(section.1)
        }
        self.apply(snap, animatingDifferences: false)
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.snapshot().sectionIdentifiers
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.snapshot().sectionIdentifiers.firstIndex(of: title) ?? 0
    }
}
extension MyDataSource : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerID)!
        h.tintColor = .red
        if h.viewWithTag(1) == nil {
            print("configuring a new header view") // only called about 8 times
            
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
                NSLayoutConstraint.constraints(withVisualFormat:"H:|-5-[lab(25)]-10-[v(40)]",
                                               metrics:nil, views:["v":v, "lab":lab]),
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[v]|",
                                               metrics:nil, views:["v":v]),
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[lab]|",
                                               metrics:nil, views:["lab":lab])
            ].flatMap {$0})
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.snapshot().sectionIdentifiers[section] // *
        return h
        
    }

}
