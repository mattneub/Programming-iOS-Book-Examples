
import UIKit

class MyLabel : UILabel {
    
    override func layoutSubviews() {
        print("layout") // just proving that the "no layout" bug is fixed
        super.layoutSubviews()
        // no longer needed; the label is configured in the nib
        // self.preferredMaxLayoutWidth = self.bounds.width
        // look ma, no hands!
        print(self.bounds.width, self.preferredMaxLayoutWidth)

    }
    
    
}
