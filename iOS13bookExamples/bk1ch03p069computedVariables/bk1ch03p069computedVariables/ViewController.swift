

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

// warning, I expect some property wrapper feature names to change in the next iteration
@propertyWrapper struct Facade<T> {
    private var _p : T
    init(wrappedValue:T) {self._p = wrappedValue}
    init(_ val:T) {self._p = val}
    var wrappedValue : T {
        get {
            return self._p
        }
        set {
            self._p = newValue
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



class ViewController: UIViewController {
    
    var mp : MPMusicPlayerController {
        MPMusicPlayerController.systemMusicPlayer // NB no longer a method
    }

    
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
    @Facade("test") var p : String
    
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
    
    @Clamped(min:-7, max:7) var clamped : Int = 0
    
    @Clamped(wrappedValue:0, min:-7, max:7) var anotherWay : Int
    
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
        
        // @Clamped var test = 4 // not yet, dude

    
    
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

