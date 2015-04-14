
import UIKit

class RootViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        // self.tableView.rowHeight = 58 // *
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    /*
    As promised, the cell will never be nil and doesn't need to be an Optional.
    But we must find another test to decide whether initial configuration is needed
    (i.e. is this a blank empty new cell or is it reused, so that it was configured
    in a previous call to cellForRow).
*/
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as! UITableViewCell
        if cell.viewWithTag(1) == nil {
            let iv = UIImageView()
            iv.tag = 1
            cell.contentView.addSubview(iv)
            
            let lab = UILabel()
            lab.tag = 2
            cell.contentView.addSubview(lab)
            
            // since we are now adding the views ourselves (not reusing the default views),
            // we can use autolayout to lay them out
            
            let d = ["iv":iv, "lab":lab]
            iv.setTranslatesAutoresizingMaskIntoConstraints(false)
            lab.setTranslatesAutoresizingMaskIntoConstraints(false)
            // image view is vertically centered
            cell.contentView.addConstraint(
                NSLayoutConstraint(item:iv, attribute:.CenterY, relatedBy:.Equal, toItem:cell.contentView, attribute:.CenterY, multiplier:1, constant:0))
            // it's a square
            cell.contentView.addConstraint(
                NSLayoutConstraint(item:iv, attribute:.Width, relatedBy:.Equal, toItem:iv, attribute:.Height, multiplier:1, constant:0))
            // label has height pinned to superview
            cell.contentView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("V:|[lab]|",
                options:nil, metrics:nil, views:d))
            // horizontal margins
            cell.contentView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[lab]-15-[iv]-15-|",
                options:nil, metrics:nil, views:d))
            
            
            lab.font = UIFont(name:"Helvetica-Bold", size:16)
            lab.lineBreakMode = .ByWordWrapping
            lab.numberOfLines = 2
            
        }
        // can refer to subviews by their tags
        
        let lab = cell.viewWithTag(2) as! UILabel
        lab.text = "The author of this book, who would rather be out dirt biking"
        
        let iv = cell.viewWithTag(1) as! UIImageView
        // shrink apparent size of image
        let im = UIImage(named:"moi.png")!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36,36), true, 0.0)
        im.drawInRect(CGRectMake(0,0,36,36))
        let im2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        iv.image = im2
        iv.contentMode = .Center
        
//        let s = NSStringFromUIEdgeInsets(cell.separatorInset)
//        println(s)
        
        return cell
    }
    
    

}