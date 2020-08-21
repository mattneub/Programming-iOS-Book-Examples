

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
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
        self.sections = Array(d).sorted {$0.key < $1.key}.map {
            Section(sectionName: $0.key, rowData: $0.value)
        }
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: self.headerID)
        
        self.tableView.sectionIndexColor = .white
        self.tableView.sectionIndexBackgroundColor = .red
        self.tableView.sectionIndexTrackingBackgroundColor = .blue
        // not useful in this situation
        // self.tableView.separatorEffect = UIBlurEffect(style: .Dark)
        
        // NEW in iOS 11!
        // if we say both of these, internal constraints do the sizing
        // (as long as the delegate doesn't override us)
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        
        // showing that indicators are killed by index
        // self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 50)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // self.tableView.flashScrollIndicators()
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerID)!
        var config = h.defaultContentConfiguration()
        config.text = self.sections[section].sectionName
        config.textProperties.color = .green
        config.textProperties.font = UIFont(name:"Georgia-Bold", size:22)!
        // this does work:
//        config.secondaryText = "Testing"
//        config.prefersSideBySideTextAndSecondaryText = true
//        config.secondaryTextProperties.color = .white
        var back = UIBackgroundConfiguration.listPlainHeaderFooter()
        back.backgroundColor = .black
        h.contentConfiguration = config
        h.backgroundConfiguration = back

        // to get the flag _after_ the text, let's insert it ourselves
        if let cv = h.contentView as? UIListContentView, cv.viewWithTag(1) == nil {
            let v = UIImageView()
            v.tag = 1
            v.image = UIImage(named:"us_flag_small.gif")
            v.contentMode = .scaleAspectFit
            h.contentView.addSubview(v)
            v.translatesAutoresizingMaskIntoConstraints = false
            v.centerYAnchor.constraint(equalTo: cv.centerYAnchor).isActive = true
            v.leadingAnchor.constraint(equalTo: cv.textLayoutGuide!.trailingAnchor, constant: 10).isActive = true
            v.widthAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        

        return h
        
    }
    
    // this seems to be unnecessary!
    // that's because it's configured in the nib
    // but if we do implement it, we have to behave sensibly
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        // return 0
//        return 30
//        // return UITableView.automaticDimension
//    }
    
    /*
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    print(view) // prove we are reusing header views
    }
    */
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // return nil
        return self.sections.map {$0.sectionName}
    }
}
