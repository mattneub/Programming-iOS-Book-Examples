

import UIKit

class Dog {
    @objc func debugQuickLookObject() -> Any {
        // displaying a dog as a square
        return UIBezierPath(rect:CGRect(x:0, y:0, width:100, height:100))
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let iv = UIImageView(image: UIImage(named:"Image")!)
        iv.frame.origin = CGPoint(x:10,y:150)
        self.view.addSubview(iv)
        
        let device = self.traitCollection.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
        print(device)
        
        var d = Dog()
        var dd = d // breakpoint here and hover over d
        print(dd)
        
        
    }



}

