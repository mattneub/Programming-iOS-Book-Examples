

import UIKit

class RootViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // the black label text turns red when the cell is selected
    // but the blue label text does not - highlightedTextColor does not work on it

    let cellID = "Cell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        
        if cell.contentView.viewWithTag(1) == nil {
            let lab = UILabel()
            print(lab.lineBreakMode.rawValue)
            lab.textColor = .blue // see if this makes any difference
            //lab.textColor = .black // yes it does! the text color must be black too
            // no! the rule is that the attributed text color must _match_ the textColor
            let color = indexPath.row == 0 ? UIColor.black : UIColor.blue
            let s = NSMutableAttributedString(string: "This is\n a test", attributes: [
                .foregroundColor : color
            ])
            lab.attributedText = s
            lab.sizeToFit()
            lab.tag = 1
            lab.highlightedTextColor = .red
            cell.contentView.addSubview(lab)
        }


        return cell
    }
}
