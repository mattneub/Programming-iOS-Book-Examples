

import UIKit

class RootViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // the black label text turns red when the cell is selected
    // but the blue label text does not - highlightedTextColor does not work on it

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if cell.contentView.viewWithTag(1) == nil {
            let lab = UILabel()
            print(lab.lineBreakMode.rawValue)
            let color = indexPath.row == 0 ? UIColor.blackColor() : UIColor.blueColor()
            let s = NSMutableAttributedString(string: "This is\n a test", attributes: [
                NSForegroundColorAttributeName : color
            ])
            lab.attributedText = s
            lab.sizeToFit()
            lab.tag = 1
            lab.highlightedTextColor = UIColor.redColor()
            cell.contentView.addSubview(lab)
        }


        return cell
    }
}
