

import UIKit


class MyTableViewCell: UITableViewCell {

    override func setSelected(selected: Bool, animated: Bool) {
        
        if selected {
            let v = UIActivityIndicatorView(activityIndicatorStyle:.WhiteLarge)
            v.color = UIColor.yellowColor()
            dispatch_async(dispatch_get_main_queue()) {
                v.backgroundColor = UIColor(white:0.2, alpha:0.6)
            }
            v.layer.cornerRadius = 10
            v.frame = v.frame.insetBy(dx: -10, dy: -10)
            let cf = self.contentView.convertRect(self.bounds, fromView:self)
            v.center = CGPointMake(cf.midX, cf.midY);
            v.frame.makeIntegralInPlace() // ?
            v.tag = 1001
            self.contentView.addSubview(v)
            v.startAnimating()

        } else {
            if let v = self.viewWithTag(1001) {
                v.removeFromSuperview()
            }
        }
        super.setSelected(selected, animated: animated)

    }

}
