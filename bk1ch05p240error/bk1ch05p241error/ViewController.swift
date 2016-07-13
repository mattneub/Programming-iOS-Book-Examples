

import UIKit

enum MyFirstError : ErrorProtocol {
    case firstMinorMistake
    case firstMajorMistake
    case firstFatalMistake
}
enum MySecondError : ErrorProtocol {
    case secondMinorMistake(i:Int)
    case secondMajorMistake(s:String)
    case secondFatalMistake
}

struct SomeStruct : ErrorProtocol {
    
}
class SomeClass : ErrorProtocol {
    
}

class MyClassyError : ErrorProtocol {
    init() {
        // self._code = 666 // nope, it's immutable
    }
}


struct SomeStruct2 : ErrorProtocol {
    let name : String
    static var someError: SomeStruct2 { return SomeStruct2(name:"howdy") }
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
            let s = try String(contentsOfFile: f)
            print(s) // we won't get here
        } catch {
            print((error as NSError).localizedDescription)
            print(error)
        }

        
        do {
            let f = "nonexistent" // path to some file, maybe
            let s = try String(contentsOfFile: f)
            print(s) // we won't get here
        } catch NSCocoaError.fileReadNoSuchFileError {
            print("no such file")
        } catch {
            print(error)
        }
        
        // new better way in beta 6
        
        do {
            let f = "nonexistent" // path to some file, maybe
            if let s = try? String(contentsOfFile: f) {
                print(s) // won't happen
            } else {
                print("I guess there was no such file, eh?")
            }
        }
        
        lab: do {
            // okay, I'm sick of failing, let's succeed for once :)
            let f = Bundle.main.pathForResource("testing", ofType: "txt")!
            guard let s = try? String(contentsOfFile: f)
                else {print("still no file"); break lab}
            print(s)
            // if we get here, s is our string
        }
        
        let err = SomeStruct()
        print(err._domain)
        print(err._code)
        
        let err2 = SomeStruct2.someError
        print(err2._domain)
        print(err2._code)
        
        let err3 = MyFirstError.firstMinorMistake
        print(err3._domain)
        print(err3._code)
        print(err3 as NSError)
        
        
    }
    
    func test() {
        for what in 1...7 {
            do {
                print("throwing!")
                switch what {
                case 1: throw MyFirstError.firstMinorMistake
                case 2: throw MyFirstError.firstMajorMistake
                case 3: throw MyFirstError.firstFatalMistake
                case 4: throw MySecondError.secondMinorMistake(i:-3)
                case 5: throw MySecondError.secondMinorMistake(i:4)
                case 6: throw MySecondError.secondMajorMistake(s:"ouch")
                case 7: throw MySecondError.secondFatalMistake
                default: break
                }
            } catch MyFirstError.firstMinorMistake {
                print("first minor mistake")
            } catch let err as MyFirstError {
                // will never be called, just testing the syntax
                print("first mistake, not minor \(err)")
            } catch MySecondError.secondMinorMistake(let i) where i < 0 {
                print("my second minor mistake \(i)")
            } catch {
                if case let MySecondError.secondMajorMistake(s) = error {
                    print("my second major mistake \(s)")
                } else {
                    print(error)
                    print(error as NSError) // showing how it appears to Objective-C
                }
                // the integer correlative of the case is the code number
                // but where does the local description come from?
                // "The operation couldn't be completed." Can I change that?
            }
        }
    }
    
    enum NotLongEnough : ErrorProtocol {
        case iSaidLongIMeantLong
    }

    func giveMeALongString(_ s:String) throws {
        if s.characters.count < 5 {
            throw NotLongEnough.iSaidLongIMeantLong
        }
        print("thanks for the string")
        
        
        // ignore the rest; I'm just testing legality of guard syntax
        
        test: if s.characters.count < 5 {
            guard s.characters.count >= 10 else {
                break test // guard is legal with shortcircuiting
            }
            throw NotLongEnough.iSaidLongIMeantLong
        }
        guard s.characters.count >= 5 else {
            throw NotLongEnough.iSaidLongIMeantLong // guard is legal with throwing
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
    
    func receiveThrower(_ f:(String) throws -> ()) {
    }
    
    func callReceiveThrower() {
        receiveThrower(giveMeALongString)
    }
    
    func callReceiveThrowerr() {
        receiveThrower {
            s in // can say "s throws in" but no need
            if s.characters.count < 5 {
                throw NotLongEnough.iSaidLongIMeantLong
            }
            print("thanks for the string")
        }
    }
    
    // ===== now let's show how it works with an actual call
    
    func receiveThrower2(_ f:(String) throws -> ()) throws {
        try f("ok?")
    }
    func receiveThrower3(_ f:(String) throws -> ()) rethrows {
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
                throw NotLongEnough.iSaidLongIMeantLong
            }
            print("thanks for the string")
        }
        receiveThrower3 { // NB if the callee `rethrows` and we don't actually throw, no `try` needed
            s in
            print("thanks for the string")
        }
    }
    
    // ===== an interesting problem with guard
    
    func howMany() -> Int {return 7}
    func testf() {
        guard howMany() > 10 else {return}
        //
        // guard let howMany = howMany() where howMany > 10 else {return}
        guard let output1 = Optional(howMany()) where output1 > 10 else {return}
        guard case let output2 = howMany() where output2 > 10 else {return}
    }


}

