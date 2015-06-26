

import UIKit

func say(s:String, times:Int, var loudly:Bool) {
    loudly = true // can't do this without "var"
}

func removeFromStringNot(var s:String, character c:Character) -> Int {
    var howMany = 0
    while let ix = s.characters.indexOf(c) {
        s.removeRange(ix...ix)
        howMany += 1
    }
    return howMany
}


func removeFromString(inout s:String, character c:Character) -> Int {
    var howMany = 0
    while let ix = s.characters.indexOf(c) {
        s.removeRange(ix...ix)
        howMany += 1
    }
    return howMany
}

class Dog {
    var name = ""
}

func changeNameOfDog(d:Dog, to tostring:String) {
    d.name = tostring // no "var", no "inout" needed
}




class ViewController: UIViewController {
    
    var button2 : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let s = "hello"
            let result = removeFromStringNot(s, character:Character("l"))
            print(result)
            print(s) // no effect on s
        }
        
        var s = "hello"
        let result = removeFromString(&s, character:Character("l"))
        print(result)
        print(s) // this is the important part!
        
        // proving that the inout parameter is _always_ changed
        
        var ss = "testing" {didSet {print("did")}}
        removeFromString(&ss, character:Character("X")) // "did", even though no change
        
        let rect = CGRectZero
        var arrow = CGRectZero
        var body = CGRectZero
        struct Arrow {
            static let ARHEIGHT : CGFloat = 0
        }
        CGRectDivide(rect, &arrow, &body, Arrow.ARHEIGHT, .MinYEdge)
        
        // proving that a class instance parameter is mutable in a function without "inout"
        
        let d = Dog()
        d.name = "Fido"
        print(d.name) // "Fido"
        changeNameOfDog(d, to:"Rover")
        print(d.name) // "Rover"

        
    }


}

extension ViewController : UIPopoverPresentationControllerDelegate {
    func popoverPresentationController(
        popoverPresentationController: UIPopoverPresentationController,
        willRepositionPopoverToRect rect: UnsafeMutablePointer<CGRect>,
        inView view: AutoreleasingUnsafeMutablePointer<UIView?>) {
            view.memory = self.button2
            rect.memory = self.button2.bounds
    }
}

