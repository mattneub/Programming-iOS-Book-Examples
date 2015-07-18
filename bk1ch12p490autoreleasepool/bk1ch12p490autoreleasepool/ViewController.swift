
import UIKit

class ViewController: UIViewController {
    
    let which = 2

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        switch which {
        case 1: self.test()
        case 2: self.test2()
        default: break
        }
    }
    
    func test() {
        let path = NSBundle.mainBundle().pathForResource("001", ofType: "png")!
        for j in 0 ..< 50 {
            for i in 0 ..< 100 {
                let im = UIImage(contentsOfFile: path)
            }
        }
    }
    
    func test2() {
        let path = NSBundle.mainBundle().pathForResource("001", ofType: "png")!
        for j in 0 ..< 50 {
            autoreleasepool {
                for i in 0 ..< 100 {
                    let im = UIImage(contentsOfFile: path)
                }
            }
        }
    }



}

