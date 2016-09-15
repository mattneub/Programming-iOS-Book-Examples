

import UIKit

func countDownFrom(ix:Int) {
    print(ix)
    if ix > 0 { // stopper
        countDownFrom(ix-1) // recurse!
    }
}


class ViewController: UIViewController {
    
    func countDownFrom2(ix:Int) {
        print(ix)
        if ix > 0 { // stopper
            countDownFrom2(ix-1) // legal
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        func countDownFrom3(ix:Int) {
            print(ix)
            if ix > 0 { // stopper
                countDownFrom3(ix-1) // new: legal in Swift 2.0
            }
        }
        

        countDownFrom(5)
        countDownFrom2(5)
        countDownFrom3(5)

    
    
    }



}

