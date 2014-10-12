
import UIKit

class MyLabel : UILabel {
    
    override func layoutSubviews() {
        println("layout") // just proving that the "no layout" bug is fixed
        super.layoutSubviews()
        // no longer needed; the label is configured in the nib
        // self.preferredMaxLayoutWidth = self.bounds.width
    }
    
    /*
    
    // okay but there's a major problem: 
    // in iOS 8, labels are not getting layoutSubviews calls at all!
    // can't tell if this is a bug or a new iOS 8 "feature"
    // even sending setNeedsLayout / layoutIfNeeded to the label ...
    // doesn't cause layoutSubviews to be called!
    
    // For purposes of *this* example, where rotation is the only thing that triggers layout,
    // I can detect the change as a change in trait collection
    // but that is hardly satisfactory; it wouldn't work on iPad,
    // where rotation does not change traits,
    // and it wouldn't work if our size changed for some other reason
    
    // thank heavens, they fixed this bug!
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        println("trait")
        delay(0.0) {
            self.preferredMaxLayoutWidth = self.bounds.width
        }
        super.traitCollectionDidChange(previousTraitCollection)
    }

*/
    
    
}
