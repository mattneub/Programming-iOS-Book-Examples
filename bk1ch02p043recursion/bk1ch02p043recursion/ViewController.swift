

import UIKit

func countDownFrom(ix:Int) {
    println(ix)
    if ix > 0 { // stopper
        countDownFrom(ix-1) // recurse!
    }
}


class ViewController: UIViewController {
    
    func countDownFrom2(ix:Int) {
        println(ix)
        if ix > 0 { // stopper
            countDownFrom2(ix-1) // legal
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        countDownFrom(5)
        
        /*
        
        func countDownFrom3(ix:Int) {
            println(ix)
            if ix > 0 { // stopper
                countDownFrom3(ix-1) // not legal because local
            }
        }

        */

    
    
    }



}

