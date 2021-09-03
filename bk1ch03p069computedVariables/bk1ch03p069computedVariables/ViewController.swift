

import UIKit
import MediaPlayer

// @Facade var testing = 0 // legal // nope, not any more

var now : String {
    get {
        return Date().description
    }
    set {
        print(newValue)
    }
}

var now2 : String { // showing you can omit "get" if there is no "set"
    return Date().description
}

var now3 : String {
    Date().description // you can also omit `return` if it's a one-liner, Swift 5.1
}

typealias SomeType = Int // just testing the syntax, ignore
@propertyWrapper struct MyWrapper {
    var wrappedValue : SomeType {
        get { 1 }
        set { /*...*/ }
    }
}

@propertyWrapper struct Facade<T> {
    private var _p : T
    init(wrappedValue:T) {
        print("called the wrappedValue initializer")
        self._p = wrappedValue}
    init(_ val:T) {
        print("called the other initializer")
        self._p = val
    }
    var wrappedValue : T {
        get {
            return self._p
        }
        set {
            self._p = newValue
        }
    }
}

@propertyWrapper struct ClampedInt { // nongeneric version
    private var _i : Int = 0
    var wrappedValue : Int {
        get {
            self._i
        }
        set {
            self._i = Swift.max(Swift.min(newValue,5),0)
        }
    }
}


@propertyWrapper struct Clamped<T:Comparable> {
    private var _i : T
    private let min : T
    private let max : T
    init(wrappedValue: T, min:T, max:T) {
        self._i = wrappedValue
        self.min = min
        self.max = max
    }
//    var delegateValue : String { // causes $name to yield "yoho" instead of struct instance
//        return "yoho"
//    }
    let projectedValue = "yoho"
    var wrappedValue : T {
        get {
            self._i
        }
        set {
            self._i = Swift.max(Swift.min(newValue,self.max),self.min)
        }
    }
}

// New in Swift 5.5, a function parameter can initialize a property wrapper
// Moreover, there are two implicit initializers

struct ROT13 { // copied from https://www.hackingwithswift.com/example-code/strings/how-to-calculate-the-rot13-of-a-string
    // create a dictionary that will store our character mapping
    private static var key = [Character: Character]()

    // create arrays of all uppercase and lowercase letters
    private static let uppercase = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private static let lowercase = Array("abcdefghijklmnopqrstuvwxyz")

    static func string(_ string: String) -> String {
        // if this is the first time the method is being called, calculate the ROT13 key dictionary
        if ROT13.key.isEmpty {
            for i in 0 ..< 26 {
                ROT13.key[ROT13.uppercase[i]] = ROT13.uppercase[(i + 13) % 26]
                ROT13.key[ROT13.lowercase[i]] = ROT13.lowercase[(i + 13) % 26]
            }
        }

        // now return the transformed string
        let transformed = string.map { ROT13.key[$0] ?? $0 }
        return String(transformed)
    }
}
extension String {
    func rot13() -> String {
        return ROT13.string(self)
    }
}

@propertyWrapper struct Rot13old {
    var wrappedValue : String
    var projectedValue : String {
        wrappedValue.rot13()
    }
}
@propertyWrapper struct Rot13 {
    let orig : String
    let ciph : String
    init(wrappedValue:String) {
        self.orig = wrappedValue
        self.ciph = wrappedValue.rot13()
    }
    init(projectedValue:String) {
        self.ciph = projectedValue
        self.orig = projectedValue.rot13()
    }
    var wrappedValue : String { self.orig }
    var projectedValue : String { self.ciph }
}


class ViewController: UIViewController {
    
    var mp : MPMusicPlayerController {
        MPMusicPlayerController.systemMusicPlayer // NB no longer a method
    }

    @MyWrapper var myProperty // can omit type, as it is known from the wrapper
    @ClampedInt var whatever // ditto, because ClampedInt is not generic
    
    // typical "facade" structure
    private var __p : String = ""
    var pFacade : String {
        get {
            self.__p
        }
        set {
            self.__p = newValue
        }
    }
    
    // Swift 5.1, can sluff the above off into a property wrapper
    // Swift 5.3, we don't need the explicit type declaration
    @Facade var ptesting = "test" // wrapped value initializer
    @Facade("test") var p // other initializer
    
    // more "practical" facade, a clamped setter
    private var _pp : Int = 0
    var pp : Int {
        get {
            self._pp
        }
        set {
            self._pp = max(min(newValue,10),0)
        }
    }
    
    @Clamped(min:-7, max:7) var clamped = 0
    
    @Clamped(wrappedValue:0, min:-7, max:7) var anotherWay
    
    // observer
    var s = "whatever" {
        willSet {
            print(newValue)
        }
        didSet {
            print(oldValue)
            // self.s = "something else"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.p)
        self.p = "howdy"
        print(self.p)
        print("underscore", _p) // the struct
        

        self.pp = 5
        print(self.pp)
        self.pp = 20
        print(self.pp)
        self.pp = -10
        print(self.pp)
        
        self.clamped = 5
        print(self.clamped)
        self.clamped = 20
        print(self.clamped)
        self.clamped = -10
        print(self.clamped)
        
        print("underscore", _clamped) // the Clamped struct
        _clamped = Clamped(wrappedValue:1, min:-6, max:6)
        print("underscore again", _clamped)
        self.clamped = 7
        print("underscore again again", _clamped)
        print(self.clamped)
        print("dollar", $clamped) // yoho, the projected value
        


    
        now = "Howdy"
        print(now)
        
        self.s = "Hello"
        self.s = "Bonjour"
        
        @Clamped(min:1, max:3) var test = 4 // now legal on local

        self.cipher(string: "hello") // init with wrapped value
        self.cipher($string: "uryyb") // init with projected value

    
    }
    
    func cipher(@Rot13 string: String) {
        print("the original string is", string)
        print("the enciphered string is", $string)
    }

    
    // old example, removed from book
    private var _myBigData : Data! = nil
    var myBigData : Data! {
        set (newdata) {
            self._myBigData = newdata
        }
        get {
            if _myBigData == nil {
                let fm = FileManager.default
                let f = fm.temporaryDirectory.appendingPathComponent("myBigData")
                if let d = try? Data(contentsOf:f) {
                    print("loaded big data from disk")
                    self._myBigData = d
                    do {
                        try fm.removeItem(at:f)
                        print("deleted big data from disk")
                    } catch {
                        print("Couldn't remove temp file")
                    }
                }
            }
            return self._myBigData
        }
    }

}

