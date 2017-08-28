

import UIKit

class ViewController2: UIViewController {
        
    var boy : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.finishInterface()
    }
    
    func finishInterface() {
        if let boy = self.boy {
            print("adding image view!")
            let im = UIImageView(image: UIImage(named:boy.lowercased()))
            self.view.addSubview(im)
            // finish positioning image view
            im.frame.origin = CGPoint(x:30,y:30)
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
            im.addGestureRecognizer(tap)
            im.isUserInteractionEnabled = true
        }
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(self.boy, forKey: "boy")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let boy = coder.decodeObject(forKey: "boy") as? String {
            self.boy = boy
        }
    }
    
    override func applicationFinishedRestoringState() {
        print("finished restoration")
        self.finishInterface()
    }

    @objc func tapped(_ : UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
}
