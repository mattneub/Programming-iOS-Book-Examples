
import UIKit

class View2Controller : UIViewController {
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Second"
        // whoa, check this out: the image comes right out of the asset catalog as a template image!
        let b = UIBarButtonItem(image: UIImage(named:"files.png"), style: .plain, target: nil, action: nil)
        // can have both left bar buttons and back bar button
        self.navigationItem.leftBarButtonItem = b
        self.navigationItem.leftItemsSupplementBackButton = true
        
        let b2 = UIBarButtonItem(title: "Haha", style: .plain, target: self, action: #selector(goAnother))
        b2.setBackgroundImage(nil, for: .normal, barMetrics: .default)
        self.navigationItem.rightBarButtonItem = b2
        
        let iv = UIImageView()
        iv.image = UIImage(named:"files.png")
        self.navigationItem.titleView = iv

        let v = UIView(frame:CGRect(0, 0, 50, 30))
        v.backgroundColor = .red
        self.navigationItem.titleView = v
        
        // but now let's play with constraints!
        let lab = UILabel()
        lab.text = "Hello"
        lab.backgroundColor = .white
        lab.translatesAutoresizingMaskIntoConstraints = false
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(lab)
        NSLayoutConstraint.activate([
            lab.topAnchor.constraint(equalTo: v.topAnchor, constant: 10),
            lab.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -10),
            lab.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 10),
            lab.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -10),
            ])
        self.navigationItem.titleView = v
        // woohoo!
        

    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .red // just so we know we're here
        
        // try with and without this
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc func goAnother(_:Any) {
        let vc = UIViewController()
        vc.navigationItem.title = "Third"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            print("we are being popped")
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent:parent) // crucial or you'll break `isMovingFromParent`
        if parent == nil {
            print("we are being popped")
        }
    }
    
    // with a back button, we get "pop" for free, both by tapping the button...
    // and interactively by dragging from the left edge
    
    // this looks like a bug: we are not getting light content
    
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .LightContent
//    }
    
//    override var prefersStatusBarHidden : Bool {
//        return false
//    }

    
}
