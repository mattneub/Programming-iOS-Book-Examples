
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
    
    let cellID = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        // self.tableView.rowHeight = 58 // *
        // row height is set in nib, and we do NOT opt out of Automatic in iOS 11
//        if #available(iOS 11.0, *) {
//            self.tableView.contentInsetAdjustmentBehavior = .never
//        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    /*
    As promised, the cell will never be nil and doesn't need to be an Optional.
    But we must find another test to decide whether initial configuration is needed
    (i.e. is this a blank empty new cell or is it reused, so that it was configured
    in a previous call to cellForRow).
*/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        if cell.viewWithTag(1) == nil { // no subviews! add them
            let iv = UIImageView()
            iv.tag = 1
            cell.contentView.addSubview(iv)
            
            let lab = UILabel()
            lab.tag = 2
            cell.contentView.addSubview(lab)
            
            // since we are now adding the views ourselves,
            // we can use autolayout to lay them out
            
            let d = ["iv":iv, "lab":lab]
            iv.translatesAutoresizingMaskIntoConstraints = false
            lab.translatesAutoresizingMaskIntoConstraints = false
            var con = [NSLayoutConstraint]()
            // image view is vertically centered
            con.append(
                iv.centerYAnchor.constraint(equalTo:cell.contentView.centerYAnchor))
            // it's a square
            con.append(
                iv.widthAnchor.constraint(equalTo:iv.heightAnchor))
            // label has height pinned to superview
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[lab]|",
                metrics:nil, views:d))
            // horizontal margins
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"H:|-15-[lab]-15-[iv]-15-|",
                metrics:nil, views:d))
            NSLayoutConstraint.activate(con)
            
            
            lab.font = UIFont(name:"Helvetica-Bold", size:16)
            lab.lineBreakMode = .byWordWrapping
            lab.numberOfLines = 2
            
        }
        // can refer to subviews by their tags
        
        let lab = cell.viewWithTag(2) as! UILabel
        lab.text = "The author of this book, who would rather be out dirt biking"
        
        let iv = cell.viewWithTag(1) as! UIImageView
        // shrink apparent size of image
        let im = UIImage(named:"moi.png")!
        let r = UIGraphicsImageRenderer(size:CGSize(36,36), format:im.imageRendererFormat)
        let im2 = r.image {
            _ in im.draw(in:CGRect(0,0,36,36))
        }
        
        iv.image = im2
        iv.contentMode = .center
        
        
        return cell
    }
    
    

}
