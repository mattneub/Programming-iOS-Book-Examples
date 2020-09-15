

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

func removeCharacterNot(_ c:Character, from s:String) -> Int {
    var s = s
    var howMany = 0
    while let ix = s.firstIndex(of:c) { // no more characters
        s.remove(at:ix)
        howMany += 1
    }
    return howMany
}



func removeCharacter(_ c:Character, from s: inout String) -> Int {
    var howMany = 0
    while let ix = s.firstIndex(of:c) { // no more characters
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
    var button : UIButton!
    var button2 : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let s = "hello"
            let result = removeCharacterNot("l", from:s)
            print(result)
            print(s) // no effect on s
        }
        
        var s = "hello"
        let result = removeCharacter("l", from:&s)
        print(result)
        print(s) // this is the important part!
        
        // proving that the inout parameter is _always_ changed
        
        var ss = "testing" {didSet {print("did")}}
        _ = removeCharacter("X", from:&ss) // "did", even though no change
        
        let myRect = CGRect.zero
        var arrow = CGRect.zero
        var body = CGRect.zero
        struct Arrow {
            static let ARHEIGHT : CGFloat = 0
        }
        // but the whole example may fall to the ground...
        // as they may be blocking access to the original C functions entirely
        // the won't let me write this:
        
        // let r = CGRectDivide(myRect, &arrow, &body, Arrow.ARHEIGHT, .minYEdge)

        // but they do seem to let me access it as a kind of method!
        // seed 4, dodged a bullet; they renamified it but they didn't kill it
        // seed 6, they renamified it further; I hope they don't totally kill it...
        myRect.__divided(slice: &arrow, remainder: &body, atDistance: Arrow.ARHEIGHT, from: .minYEdge)
        
        // hmm, maybe I can subsitute this example:
        
        let c = UIColor.purple
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
        c.getRed(&r, green: &g, blue: &b, alpha: &a)
        print(r,g,b,a)
        
        // proving that a class instance parameter is mutable in a function without "inout"
        
        let d = Dog()
        d.name = "Fido"
        print(d.name) // "Fido"
        changeName(of:d, to:"Rover")
        print(d.name) // "Rover"
        
        
    }


}


extension ViewController : UIPopoverPresentationControllerDelegate {
    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
        print("reposition")
        if view.pointee == self.button {
            rect.pointee = self.button2.bounds
            view.pointee = self.button2
        }
    }
}
 

