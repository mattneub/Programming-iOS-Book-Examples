
import UIKit

class MyLabel : UILabel {
    
    override func layoutSubviews() {
        // proving that UILabel's layoutSubviews is never being called, a huge iOS 8 bug in my opinion
        super.layoutSubviews()
        println("label layout")
    }
    
}
