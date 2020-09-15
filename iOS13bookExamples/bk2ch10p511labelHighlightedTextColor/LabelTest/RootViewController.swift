

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
    
    let cellID = "Cell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        
        if cell.contentView.viewWithTag(1) == nil {
            let lab = UILabel()
            print(lab.lineBreakMode.rawValue)
            // the rule is that in order for the highlighted text color to affect
            // an attributed label,
            // the attributed text color must _match the textColor_

            lab.textColor = .blue
            // lab.textColor = .black // reverses which cell turns red when highlighted
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
