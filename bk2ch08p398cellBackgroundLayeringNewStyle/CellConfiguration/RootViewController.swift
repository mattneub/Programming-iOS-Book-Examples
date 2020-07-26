
import UIKit

class RootViewController : UITableViewController {
    let cellID = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MyCell.self, forCellReuseIdentifier: self.cellID)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    // rewrite using the iOS 14 cell configuration architecture
    /*
    the window background never appears
    the table view background appears when you "bounce" the scroll beyond its limits
    (in iOS 11 I'm letting it show behind the status bar initially)
    the red cell background color is behind the cell
    the linen cell background view is on top of that
    the (translucent, here) selected background view is on top of that
    the content view and its contents are on top of that
    */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        
        // the content we can do ourselves right here
        var config = cell.defaultContentConfiguration()
        config.textProperties.color = .white
        // config.textProperties.color = .red
        config.text = "Hello there! \(indexPath.row)"
        cell.contentConfiguration = config
        
        // showing how to associate another view with the existing view!
        // not forgetting that cells are still reused of course...
        if let cv = cell.contentView as? UIListContentView,
           cv.viewWithTag(1) == nil {
            let guide = cv.textLayoutGuide!
            let iv = UIImageView(image: UIImage(systemName: "hand.point.left"))
            iv.tag = 1
            iv.tintColor = .black
            iv.translatesAutoresizingMaskIntoConstraints = false
            cv.addSubview(iv)
            iv.leadingAnchor.constraint(equalToSystemSpacingAfter: guide.trailingAnchor, multiplier: 1).isActive = true
            iv.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        }
        
        // but in order to get different configuration when selected,
        // we have to use the cell subclass - so tell the cell to do so
        // actually no, so I don't understand what this is for
        // cell.automaticallyUpdatesBackgroundConfiguration = false
        
//        var back = UIBackgroundConfiguration.listPlainCell()
//        back.backgroundColor = .red
//        let v = UIImageView(image: UIImage(named:"linen.png"))
//        v.contentMode = .scaleToFill
//        back.customView = v
//        cell.backgroundConfiguration = back
        
        return cell
    }
}

// and here's the cell subclass

class MyCell : UITableViewCell {
    override func updateConfiguration(using state: UICellConfigurationState) {
        var back = UIBackgroundConfiguration.listPlainCell().updated(for: state)
//        self.backgroundConfiguration = back
//        return;
        //
        let v = UIImageView(image: UIImage(named:"linen.png"))
        v.contentMode = .scaleToFill
        // there is no selectedCustomView; we just change the custom view _ourselves_ when selected
        if state.isSelected || state.isHighlighted {
            let v2 = UIView()
            v2.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
            v.addSubview(v2)
            v2.frame = v.bounds
            v2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        back.customView = v
        back.backgroundColor = .red
        // tried animating this but it was a failure
        self.backgroundConfiguration = back
    }
}


