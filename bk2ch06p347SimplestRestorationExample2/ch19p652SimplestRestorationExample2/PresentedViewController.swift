
import UIKit

class PresentedViewController : UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self.dynamicType) will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self.dynamicType) did appear")
    }

    override func encodeRestorableState(with coder: NSCoder) {
        print("\(self.dynamicType) encode \(coder)")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        print("\(self.dynamicType) decode \(coder)")
    }
    
    override func applicationFinishedRestoringState() {
        print("finished \(self.dynamicType)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load \(self.dynamicType)")
        self.view.backgroundColor = .blue
        let button = UIButton(type:.system)
        button.setTitle("Dismiss", for:[])
        button.addTarget(self,
            action:#selector(doDismiss),
            for:.touchUpInside)
        button.sizeToFit()
        button.center = self.view.center
        button.backgroundColor = .white
        self.view.addSubview(button)
    }
    
    func doDismiss(_ sender:AnyObject?) {
        self.presentingViewController!.dismiss(animated:true)
    }
    
}
