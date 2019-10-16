
import UIKit

class MyCell : UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:.default, reuseIdentifier: reuseIdentifier)
        // change .default to another built-in style if desired
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cvb = self.contentView.bounds
        let imf = self.imageView!.frame
        self.imageView!.frame.origin.x = cvb.size.width - imf.size.width - 15
        self.textLabel!.frame.origin.x = 15
    }
}
