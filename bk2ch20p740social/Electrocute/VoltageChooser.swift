

import UIKit
import Social
import MobileCoreServices

class VoltageChooser : UIViewController {
    
    
    weak var delegate : ShareViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let seg = UISegmentedControl(items:["High", "Insane"])
        seg.sizeToFit()
        seg.center = CGPointMake(self.view.bounds.midX, self.view.bounds.midY)
        seg.autoresizingMask = .FlexibleRightMargin | .FlexibleLeftMargin | .FlexibleTopMargin | .FlexibleBottomMargin
        self.view.addSubview(seg)
        seg.addTarget(self, action: "doTap:", forControlEvents: .ValueChanged)
    }
    
    
    func doTap (sender : UISegmentedControl) {
        if let svc = self.delegate {
            svc.userChose(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)
        }
    }
    
    
}
