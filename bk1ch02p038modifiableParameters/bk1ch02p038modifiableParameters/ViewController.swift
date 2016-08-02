

import UIKit

// This will go away, because it is, after all, rather misleading
/*
 func say(s:String, times:Int, var loudly:Bool) {
 loudly = true // can't do this without "var"
 }
 */

// instead, write this:

func say(s:String, times:Int, loudly:Bool) {
    var loudly = loudly
    loudly = true
    _ = loudly
}


// This will go away, because it is, after all, rather misleading
/*
 func removeFromStringNot(var s:String, character c:Character) -> Int {
 var howMany = 0
 while let ix = s.characters.indexOf(c) {
 s.removeRange(ix...ix)
 howMany += 1
 }
 return howMany
 }
 */

// instead, write this:

func removeFromStringNot(_ s:String, character c:Character) -> Int {
    var s = s
    var howMany = 0
    while let ix = s.characters.index(of:c) {
        s.remove(at:ix)
        howMany += 1
    }
    return howMany
}



func remove(from s: inout String, character c:Character) -> Int {
    var howMany = 0
    while let ix = s.characters.index(of:c) {
        s.remove(at:ix)
        howMany += 1
    }
    return howMany
}

class Dog {
    var name = ""
}

func changeName(of d:Dog, to newName:String) {
    d.name = newName // no "var", no "inout" needed
}





class ViewController: UIViewController {
    
    var button2 : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let s = "hello"
            let result = removeFromStringNot(s, character:"l")
            print(result)
            print(s) // no effect on s
        }
        
        var s = "hello"
        let result = remove(from:&s, character:"l")
        print(result)
        print(s) // this is the important part!
        
        // proving that the inout parameter is _always_ changed
        
        var ss = "testing" {didSet {print("did")}}
        _ = remove(from:&ss, character:"X") // "did", even though no change
        
        let myRect = CGRect.zero
        var arrow = CGRect.zero
        var body = CGRect.zero
        struct Arrow {
            static let ARHEIGHT : CGFloat = 0
        }
        // but the whole example may fall to the ground...
        // as they may be blocking access to the original C functions entirely
        // but they do seem to let me access it as a kind of method!
        // CGRectDivide(rect, &arrow, &body, Arrow.ARHEIGHT, .MinYEdge)
        // seed 4, dodged a bullet; they renamified it but they didn't kill it
        myRect.divided(slice: &arrow, remainder: &body, atDistance: Arrow.ARHEIGHT, from: .minYEdge)
        
        // proving that a class instance parameter is mutable in a function without "inout"
        
        let d = Dog()
        d.name = "Fido"
        print(d.name) // "Fido"
        changeName(of:d, to:"Rover")
        print(d.name) // "Rover"
        
        
    }


}


extension ViewController : UIPopoverPresentationControllerDelegate {
    @objc(popoverPresentationController:willRepositionPopoverToRect:inView:)
    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {

    }
}
 

