
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
    
    @IBInspectable var borderColor : UIColor? {
        get {
            let cg = self.layer.borderColor
            return cg == nil ? nil : UIColor(CGColor: cg!)
        }
        set {
            self.layer.borderColor = newValue?.CGColor ?? nil
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.layer.shadowColor = UIColor.grayColor().CGColor
        self.layer.shadowOffset = CGSizeMake(2,2)
        self.layer.shadowOpacity = 0.7
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.redColor()
    }
}
