
import UIKit

class MyCell : UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        let cvb = self.contentView.bounds
        var imf = self.imageView.frame
        imf.origin.x = cvb.size.width - imf.size.width - 15
        self.imageView.frame = imf
        var tf = self.textLabel.frame
        tf.origin.x = 15
        self.textLabel.frame = tf

    }
}
