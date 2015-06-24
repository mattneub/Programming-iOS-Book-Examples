

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
            let s : String = try
                String(contentsOfFile: "nonexistent", encoding: NSUTF8StringEncoding)
            print(s) // we won't get here
        } catch NSCocoaError.FileReadNoSuchFileError {
            print("no such file")
        } catch {
            print(error)
        }
        
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
            } catch is MyFirstError {
                print("first mistake, not minor")
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
    
    func giveMeALongString(s:String) throws {
        enum NotLongEnough : ErrorType {
            case ISaidLongIMeantLong
        }
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



}

