

import UIKit

enum MyFirstError : ErrorType {
    case FirstMinorMistake
    case FirstMajorMistake
    case FirstFatalMistake
}
enum MySecondError : ErrorType {
    case SecondMinorMistake(i:Int)
    case SecondMajorMistake(s:String)
    case SecondFatalMistake
}

struct SomeStruct : ErrorType {

}
struct SomeClass : ErrorType {
    
}


class ViewController: UIViewController {
    
    var ok = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        test: do {
            break test // labeled break to a do is legal
        }
        
        self.test()
        
        self.stringTest()
        self.stringTest2()
        
        do {
            let f = "nonexistent" // path to some file, maybe
            let s = try String(contentsOfFile: f, encoding: NSUTF8StringEncoding)
            print(s) // we won't get here
        } catch NSCocoaError.FileReadNoSuchFileError {
            print("no such file")
        } catch {
            print(error)
        }
        
        // new better way in beta 6
        
        do {
            let f = "nonexistent" // path to some file, maybe
            if let s = try? String(contentsOfFile: f, encoding: NSUTF8StringEncoding) {
                print(s) // won't happen
            } else {
                print("I guess there was no such file, eh?")
            }
        }
        
        lab: do {
            // okay, I'm sick of failing, let's succeed for once :)
            let f = NSBundle.mainBundle().pathForResource("testing", ofType: "txt")!
            guard let s = try? String(contentsOfFile: f, encoding: NSUTF8StringEncoding)
                else {print("still no file"); break lab}
            print(s)
            // if we get here, s is our string
        }
        
        let err = SomeStruct()
        print(err._domain)
        print(err._code)
        
    }
    
    func test() {
        for what in 1...7 {
            do {
                print("throwing!")
                switch what {
                case 1: throw MyFirstError.FirstMinorMistake
                case 2: throw MyFirstError.FirstMajorMistake
                case 3: throw MyFirstError.FirstFatalMistake
                case 4: throw MySecondError.SecondMinorMistake(i:-3)
                case 5: throw MySecondError.SecondMinorMistake(i:4)
                case 6: throw MySecondError.SecondMajorMistake(s:"ouch")
                case 7: throw MySecondError.SecondFatalMistake
                default: break
                }
            } catch MyFirstError.FirstMinorMistake {
                print("first minor mistake")
            } catch let err as MyFirstError {
                // will never be called, just testing the syntax
                print("first mistake, not minor \(err)")
            } catch MySecondError.SecondMinorMistake(let i) where i < 0 {
                print("my second minor mistake \(i)")
            } catch {
                if case let MySecondError.SecondMajorMistake(s) = error {
                    print("my second major mistake \(s)")
                } else {
                    print(error as NSError) // showing how it appears to Objective-C
                }
                // the integer correlative of the case is the code number
                // but where does the local description come from?
                // "The operation couldn't be completed." Can I change that?
            }
        }
    }
    
    enum NotLongEnough : ErrorType {
        case ISaidLongIMeantLong
    }

    func giveMeALongString(s:String) throws {
        if s.characters.count < 5 {
            throw NotLongEnough.ISaidLongIMeantLong
        }
        print("thanks for the string")
        
        
        // ignore the rest; I'm just testing legality of guard syntax
        
        test: if s.characters.count < 5 {
            guard s.characters.count >= 10 else {
                break test // guard is legal with shortcircuiting
            }
            throw NotLongEnough.ISaidLongIMeantLong
        }
        guard s.characters.count >= 5 else {
            throw NotLongEnough.ISaidLongIMeantLong // guard is legal with throwing
        }
        guard s.characters.count >= 5 else {
            print("I'm out of here")
            fatalError("this is nuts") // guard is legal with fatalError
        }
        
        while true {
            guard !ok else {
                break // guard is legal with unlabeled break / continue
            }
        }
        
        let optionalString : String? = "howdy"
        guard let _ = optionalString else {
            return
        }
    }
    
    func stringTest() {
        do {
            try giveMeALongString("is this long enough for you?")
        } catch {
            print("I guess it wasn't long enough: \(error)")
        }
    }
    
    func stringTest2() {
        try! giveMeALongString("okayokay")
    }
    
    // ===== just testing the call syntax and legality
    
    func receiveThrower(f:(String) throws -> ()) {
    }
    
    func callReceiveThrower() {
        receiveThrower(giveMeALongString)
    }
    
    func callReceiveThrowerr() {
        receiveThrower {
            s in
            if s.characters.count < 5 {
                throw NotLongEnough.ISaidLongIMeantLong
            }
            print("thanks for the string")
        }
    }
    
    // ===== now let's show how it works with an actual call
    
    func receiveThrower2(f:(String) throws -> ()) throws {
        try f("ok?")
    }
    func receiveThrower3(f:(String) throws -> ()) rethrows {
        try f("ok?")
    }

    
    func callReceiveThrower2() throws {
        try receiveThrower2(giveMeALongString)
        try receiveThrower3(giveMeALongString)
    }
    
    func callReceiveThrowerr2() throws {
        try receiveThrower2 {
            s in
            if s.characters.count < 5 {
                throw NotLongEnough.ISaidLongIMeantLong
            }
            print("thanks for the string")
        }
        receiveThrower3 { // NB if the callee `rethrows` and we don't actually throw, no `try` needed
            s in
            print("thanks for the string")
        }
    }


}

