

import UIKit

func doThis(f:()->()) {
    f()
}

func sayHowdy() -> String {
    return "Howdy"
}
func performAndPrint(f:()->String) {
    let s = f()
    println(s)
}



class ViewController: UIViewController {

    @IBOutlet weak var myButton2: UIButton!
    @IBOutlet weak var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doThis { // no parentheses!
            println("Howdy")
        }
        
        performAndPrint {
            sayHowdy() // meaning: return sayHowdy()
        }

        let arr = [2, 4, 6, 8]
        let arr2 = arr.map {$0*2} // it doesn't get any Swiftier than this
        println(arr2)

        
    }

    @IBAction func doButton(sender: AnyObject) {
        
        
        UIView.animateWithDuration(0.4, animations: {
            () -> () in
            self.myButton.frame.origin.y += 20
            }, completion: {
                (finished:Bool) -> () in
                println("finished: \(finished)")
        })

        
    }
    
    @IBAction func doButton2(sender: AnyObject) {
        
        // showing some serious compression of the above syntax
        
        UIView.animateWithDuration(0.4, animations: {
            self.myButton2.frame.origin.y += 20
            }) {
                println("finished: \($0)") // must have either "_ in" or "$0"
        }

        
    }
    


}

