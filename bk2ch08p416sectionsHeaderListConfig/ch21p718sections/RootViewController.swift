

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
        config.imageProperties.maximumSize = CGSize(0,20)
        config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 2, leading: -10, bottom: 2, trailing: 30)
        config.image = UIImage(named:"us_flag_small.gif")
        config.imageToTextPadding = 6
        var back = UIBackgroundConfiguration.listPlainHeaderFooter()
        back.backgroundColor = .black
        h.contentConfiguration = config
        h.backgroundConfiguration = back
        /*
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
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.sections[section].sectionName
        // print(h.backgroundView?.backgroundColor)
        // h.textLabel!.text = "THIS IS A TEST"
 */
        
        // hmm, but you can't do this because there is no text label
        // so how can you coordinate custom views with default views?
        /*
        let b = UIButton(type:.system)
        b.setTitle("Howdy", for:.normal)
        b.sizeToFit()
        print(b.tintColor, h.tintColor)
        h.contentView.addSubview(b)
        let lab = h.textLabel!
        b.leadingAnchor.constraint(equalTo: lab.trailingAnchor, constant: 10).isActive = true
        b.centerYAnchor.constraint(equalTo: h.contentView.centerYAnchor).isActive = true
 */

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
        return self.sections.map{$0.sectionName}
    }
}
