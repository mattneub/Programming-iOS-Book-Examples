
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
        self.tableView.register(MyCell.self, forCellReuseIdentifier: self.cellID)
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.tableView.rowHeight = 58
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! MyCell
        if cell.textLabel!.numberOfLines != 2 { // never previously configured
            cell.textLabel!.font = UIFont(name:"Helvetica-Bold", size:16)
            cell.textLabel!.lineBreakMode = .byWordWrapping
            cell.textLabel!.numberOfLines = 2
        }
        
        cell.textLabel!.text = "The author of this book, who would rather be out dirt biking"
        
        // shrink apparent size of image
        let im = UIImage(named:"moi.png")!
        let r = UIGraphicsImageRenderer(size:CGSize(36,36), format:im.imageRendererFormat)
        let im2 = r.image {
            _ in im.draw(in:CGRect(0,0,36,36))
        }

        
        cell.imageView!.image = im2
        cell.imageView!.contentMode = .center
        
        print(cell.separatorInset)
        
        return cell
    }
    
    /*
    You can see we are using the nib, because the table view has a green background.
*/
    

}
