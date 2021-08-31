

import UIKit

// how to make a global actor
@globalActor struct MyGlobalActor {
    actor MyActor {}
    static let shared = MyActor()
}

@MainActor class MySuper {}
class MyClass : MySuper {
    // and we can bind a method to our global actor
    @MyGlobalActor func f() {}
    
    func g() {
        print(Thread.isMainThread)
    }
}


@MainActor var what = "howdy"

@MainActor func f() {}

actor Counter {
    let id : String
    var total = 0
    init(id:String) {
        self.id = id
    }
    func inc() {
        self.total += 1
    }
    func dec() {
        self.total -= 1
    }
    // good candidate for nonisolated because it touches only a constant of self
    nonisolated func capID() -> String {
        return self.id.capitalized
    }
    func reportTotal() -> Int {
        return self.total
    }
}

// hey, read-only computed getters can now throw!
struct MyStruct {
    struct MyError : Error {}
    var date : Date {
        get throws {
            if Bool.random() {
                throw MyError()
            }
            return Date.now
//        } set {
//            print(newValue)
        }
    }
}

class Dog {
    private var _name : String?
    func setName(_ newName: String) {
        self._name = newName
    }
    var name : String {
        get throws {
            enum UndefinedError : Error {
                case noName
            }
            guard let name = _name else {
                throw UndefinedError.noName
            }
            return name
        }
    }
    // read-only subscripts can throw too
    subscript() -> Character {
        get throws {
        enum UndefinedError : Error {
            case noName
        }
        throw UndefinedError.noName
        return "C"
        }
//        set {
//            
//        }
    }
}

class ViewController: UIViewController {
    @MyGlobalActor class var what : String { "howdy" }
    @MyGlobalActor class func ff() {}
    func callG() async {
        print(Thread.isMainThread)
        MyClass().g()
    }
    var which = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch which {
        case 0:
            // demonstrate what I regard as a bug
            // MyClass is a subclass of a MainActor bound class
            // ViewController is a subclass of a MainActor bound class
            // but non-override methods of those subclasses are not MainActor bound
            Task.detached {
                await self.callG() // false! false!
            }
        case 1:
            // demonstrate a throwing getter
            let d = Dog()
            // uncomment next line as desired
            // d.setName("fido")
            if let name = try? d.name {
                print("dog's name is", name)
            } else {
                print("dog has no name yet")
                d.setName("rover")
                if let name = try? d.name {
                    print("dog's name is now", name)
                }
            }
        case 2:
            Task {
                await f()
                let counter = Counter(id:"matt")
                let total = await counter.total
                await counter.inc() // fine
                await counter.dec() // fine
                let id = counter.id // fine
                // this next line is a compile error...
                // unless we _either_ say await...
                // _or_ declare capID nonisolated
                let capID = counter.capID()
            }
        default: break
        }
        return;
        
        // this line is a compile error because `counter` is an isolated Counter
        // self.inc(counter: Counter(id: "matt"))
        // we can only call this using `await`, even though the function is declared here

    }
    // this is a compile error if we don't say `isolated Counter`
    func inc(counter: isolated Counter) {
        counter.inc()
    }
    // _this_ method can call inc(counter:) because it is async and can say await
    func callInc() async {
        let counter = Counter(id: "matt")
        await self.inc(counter: counter)
    }
    @MyGlobalActor func f() {
        print("hello")
    }
    @MyGlobalActor func g() {
        f()
    }
}


