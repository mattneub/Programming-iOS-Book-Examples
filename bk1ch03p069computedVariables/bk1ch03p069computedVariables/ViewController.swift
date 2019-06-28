

import UIKit
import MediaPlayer

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
    init(initialValue:T) {self._p = initialValue}
    init(_ val:T) {self._p = val}
    var value : T {
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
    init(_ initial : T, min:T, max:T) {
        self._i = initial
        self.min = min
        self.max = max
    }
//    var delegateValue : String { // causes $name to yield "yoho" instead of struct instance
//        return "yoho"
//    }
    let delegateValue = "yoho"
    var value : T {
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
    private var _p : String = ""
    var pFacade : String {
        get {
            self._p
        }
        set {
            self._p = newValue
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
    
    @Clamped(0, min:-7, max:7) var clamped : Int {
        didSet { // proving they are allowed to have observers (but not always: see @State)
            print("did")
        }
        willSet {
            print("will")
        }
    }
    
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
        print("dollar", $p) // the struct
        

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
        
        print("dollar", $clamped)
        // $clamped = Clamped(0, min:-6, max:6)
        print("dollar dollar", $__delegate_storage_$_clamped)
        


    
        now = "Howdy"
        print(now)
        
        self.s = "Hello"
        self.s = "Bonjour"

    
    
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

