

import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



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
            im.frame.origin = CGPoint(30,30)
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
            im.addGestureRecognizer(tap)
            im.isUserInteractionEnabled = true
        }
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(self.boy, forKey: "boy")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let boy = coder.decodeObject(of:NSString.self, forKey: "boy") {
            self.boy = boy as String
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
