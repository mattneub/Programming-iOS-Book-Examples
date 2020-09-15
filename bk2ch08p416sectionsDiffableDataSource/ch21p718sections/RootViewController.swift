

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

// failed experiment; I guess we can never get that to work
// so we can never get section index titles using the new architecture????? I've filed a bug
// oooh started working Xcode 13 beta 6
class MyDataSource : UITableViewDiffableDataSource<String,String> {
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.snapshot().sectionIdentifiers[section]
//    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.snapshot().sectionIdentifiers
    }
    // still doesn't actually do anything unless we also do this, sheesh this is idiotic
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.snapshot().sectionIdentifiers.firstIndex(of: title) ?? 0
    }
}

class RootViewController : UITableViewController {
    
    lazy var datasource : UITableViewDiffableDataSource<String,String> =
        MyDataSource(tableView: self.tableView) {
            tv,ip,s in
            let cell = tv.dequeueReusableCell(withIdentifier: self.cellID, for: ip)
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
        let sections = Array(d).sorted{$0.key < $1.key} // *
        
        var snap = NSDiffableDataSourceSnapshot<String,String>() // whoa, now struct?
        for section in sections {
            snap.appendSections([section.0])
            snap.appendItems(section.1)
        }
        self.datasource.apply(snap, animatingDifferences: false)
                
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: self.headerID)
        
        // all pointless: there is no section index possible with the new architecture
        self.tableView.sectionIndexColor = .white
        self.tableView.sectionIndexBackgroundColor = .red
        self.tableView.sectionIndexTrackingBackgroundColor = .blue
        // not useful in this situation
        // self.tableView.separatorEffect = UIBlurEffect(style: .Dark)
        
        // NEW in iOS 11!
        // if we say both of these, internal constraints do the sizing
        // (as long as the delegate doesn't override us)
//        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedSectionHeaderHeight = UITableViewAutomaticDimension
        
        // showing that indicators are killed by index
        // self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 50)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // self.tableView.flashScrollIndicators()
    }
            
    // NB this will _never_ be called; we are no longer the data source!
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
//        return nil
//        return self.datasource.snapshot().sectionIdentifiers[section]
    }

    // this is more "interesting"
    // func tableViewNOT(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
                ].flatMap{$0})
            
            // uncomment to see bug where button does not inherit superview's tint color
            // ooooh, bug is fixed
//            let b = UIButton(type:.system)
//            b.setTitle("Howdy", for:.normal)
//            b.sizeToFit()
//            print(b.tintColor, h.tintColor)
//            h.contentView.addSubview(b)
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.datasource.snapshot().sectionIdentifiers[section] // *
        // print(h.backgroundView?.backgroundColor)
        // h.textLabel!.text = "THIS IS A TEST"
        return h
        
    }
    
    // this seems to be unnecessary!
    // that's because it's configured in the nib
    // but if we do implement it, we have to behave sensibly
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
    
    // this will never be called, and I don't see how to get section index titles at all
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
        // return self.sections.map{$0.sectionName}
    }
}
