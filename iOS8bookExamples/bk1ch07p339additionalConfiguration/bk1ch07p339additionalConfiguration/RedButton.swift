
import UIKit

class RedButton: UIButton {
    @IBInspectable var borderWidth : CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.layer.borderColor = UIColor.greenColor().CGColor
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.redColor()
    }
}
