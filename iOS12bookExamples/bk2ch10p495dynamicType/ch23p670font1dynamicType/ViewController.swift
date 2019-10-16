

import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var lab : UILabel!
    
    @IBOutlet weak var lab2: UILabel!
    
    @IBOutlet weak var bigButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // just testing, pay no attention
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { _ in
            print(UIFont.preferredFont(forTextStyle: .headline))
            print(UIFont.buttonFontSize)
            print(UIFont.labelFontSize)
        }
        
        // hold my beer, and watch THIS!
        // self.lab.adjustsFontForContentSizeCategory = true // ta-daaaaaa!
        // NO! hold my beer, and watch THIS!!!! I can comment out that line, because I can set it in IB
        
        // but this you can't do in IB (hold my margarita this time):
        
        self.lab2.font = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: self.lab2.font)
        self.lab2.adjustsFontForContentSizeCategory = true

        
        // and presto, it is now dynamic! wow!!!!!
        
        // similarly for a button...
        // adjustsFontForContentSizeCategory applies only to UILabel, UITextField, UITextView
        // but a button's title _is_ a label:
        
        self.bigButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: UIFont.buttonFontSize))
        self.bigButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
    }
    
    override func traitCollectionDidChange(_ oldtc: UITraitCollection?) {
        let newsize = self.traitCollection.preferredContentSizeCategory
        let oldsize = oldtc?.preferredContentSizeCategory
        if newsize != oldsize {
            print("changed size!", newsize)
        }
    }
    
    
}
