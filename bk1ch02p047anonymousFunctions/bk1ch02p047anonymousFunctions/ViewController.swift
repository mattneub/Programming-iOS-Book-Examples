

import UIKit

func doThis(f:()->()) {
    f()
}

func sayHowdy() -> String {
    return "Howdy"
}
func performAndPrint(_ f:()->String) {
    let s = f()
    print(s)
}

func imageOfSize(_ size:CGSize, _ whatToDraw:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    whatToDraw()
    let result = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return result
}

func test(h:(Int, Int, Int) -> Int) {
    
}



class ViewController: UIViewController {

    @IBOutlet weak var myButton2: UIButton!
    @IBOutlet weak var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = imageOfSize(CGSize(width:45, height:20), {
            let p = UIBezierPath(
                roundedRect: CGRect(x:0,y:0,width:45,height:20), cornerRadius: 8)
            p.stroke()
        })
        
        test {
            _ in // showing that _ can mean "ignore _all_ parameters"
            return 0
        }

        
        doThis { // no parentheses!
            print("Howdy")
        }
        
        performAndPrint {
            sayHowdy() // meaning: return sayHowdy()
        }

        let arr = [2, 4, 6, 8]
        
        func doubleMe(i:Int) -> Int {
            return i*2
        }
        let arr2 = arr.map(doubleMe) // [4, 8, 12, 16]
        print(arr2)
        
        let arr3 = arr.map {$0*2} // it doesn't get any Swiftier than this
        print(arr3)

        
    }

    @IBAction func doButton(_ sender: AnyObject) {
        
        
        UIView.animate(withDuration:0.4, animations: {
            () -> () in
            self.myButton.frame.origin.y += 20
            }, completion: {
                (finished:Bool) -> () in
                print("finished: \(finished)")
        })

        
    }
    
    @IBAction func doButton2(_ sender: AnyObject) {
        
        // showing some serious compression of the above syntax
        
        UIView.animate(withDuration:0.4, animations: {
            self.myButton2.frame.origin.y += 20
            }) {
                print("finished: \($0)") // must have either "_ in" or "$0"
        }

        
    }
    


}

