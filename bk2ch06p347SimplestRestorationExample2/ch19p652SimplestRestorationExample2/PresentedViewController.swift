
import UIKit

class PresentedViewController : UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(type(of:self)) will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(type(of:self)) did appear")
    }

    override func encodeRestorableState(with coder: NSCoder) {
        print("\(type(of:self)) encode \(coder)")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        print("\(type(of:self)) decode \(coder)")
    }
    
    override func applicationFinishedRestoringState() {
        print("finished \(type(of:self))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load \(type(of:self))")
        self.view.backgroundColor = .blue
        let button = UIButton(type:.system)
        button.setTitle("Dismiss", for:.normal)
        button.addTarget(self,
            action:#selector(doDismiss),
            for:.touchUpInside)
        button.sizeToFit()
        button.center = self.view.center
        button.backgroundColor = .white
        self.view.addSubview(button)
    }
    
    @objc func doDismiss(_ sender: Any?) {
        self.presentingViewController?.dismiss(animated:true)
    }
    
}
