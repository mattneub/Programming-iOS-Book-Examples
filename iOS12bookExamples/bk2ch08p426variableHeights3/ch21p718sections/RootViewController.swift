

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
        // not useful in this situation
        // self.tableView.separatorEffect = UIBlurEffect(style: .Dark)
        
        // headers and cells are all sized automatically by internal constraints!
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        
        // but table header view is not...
        let hv = UITableViewHeaderFooterView(frame:(CGRect(0,0,1,1)))
        hv.translatesAutoresizingMaskIntoConstraints = false // doesn't help
        hv.contentView.backgroundColor = .blue
        let lab = UILabel()
        lab.text = "States"
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        lab.translatesAutoresizingMaskIntoConstraints = false
        hv.contentView.addSubview(lab)
        NSLayoutConstraint.activate([
            lab.topAnchor.constraint(equalTo: hv.contentView.topAnchor, constant: 10),
            lab.bottomAnchor.constraint(equalTo: hv.contentView.bottomAnchor, constant: -10),
            lab.centerXAnchor.constraint(equalTo: hv.contentView.centerXAnchor),
        ])
        // okay, so I was _hoping_ that the table header view would be _sized_ by its constraints too
        // but it isn't; you have to give it an absolute height or you won't see it
        // only reason for using UITableViewHeaderFooterView is content view obeys the safe area?
        
        var which : Int { return 1 }
        switch which {
        case 1:
            let sz = hv.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            hv.bounds.size.height = sz.height // this is what I should NOT have to do
        case 2:
            // failed experiment
            hv.bounds.size.height = UITableView.automaticDimension
        case 3:
            // failed experiment
            let c = hv.contentView.heightAnchor.constraint(equalToConstant:200)
            // c.priority = UILayoutPriority(rawValue:100)
            c.isActive = true
        default:break
        }
        
        
        
        self.tableView.tableHeaderView = hv
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rowData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        
        if cell.contentView.constraints.count == 0 {
            cell.textLabel!.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cell.contentView.topAnchor.constraint(equalTo: cell.textLabel!.topAnchor, constant:-20),
                cell.contentView.bottomAnchor.constraint(equalTo: cell.textLabel!.bottomAnchor, constant:20),
                cell.contentView.leadingAnchor.constraint(equalTo: cell.textLabel!.leadingAnchor, constant:-100),
            ])
        }
        
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
        // return self.sectionNames[section]
    }

    // this is more "interesting"
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView.dequeueReusableHeaderFooterView(withIdentifier:self.headerID)!
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
                NSLayoutConstraint.constraints(withVisualFormat:"V:|-10-[v]-10-|",
                    metrics:nil, views:["v":v]),
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[lab]|",
                    metrics:nil, views:["lab":lab])
                ].flatMap{$0})
            
            // uncomment to see bug where button does not inherit superview's tint color
//            let b = UIButton(type:.system)
//            b.setTitle("Howdy", for:.normal)
//            b.sizeToFit()
//            print(b.tintColor)
//            h.addSubview(b)
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.sections[section].sectionName
        // print(h.backgroundView?.backgroundColor)
        return h
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sections.map{$0.sectionName}
    }
    
}
