

import UIKit
import MediaPlayer
import SwiftUI

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
@propertyWrapper struct Facade {
    private var _p : String
    init(_ initialValue:String = "") {self._p = initialValue}
    var value : String {
        get {
            return self._p
        }
        set {
            self._p = newValue
        }
    }
}

@propertyWrapper struct Clamped {
    private var _i : Int = 0
    private let min : Int
    private let max : Int
    init(min:Int = 0, max:Int = 10) {
        self.min = min
        self.max = max
    }
    var delegateValue : String { // causes $name to yield "yoho" instead of struct instance
        return "yoho"
    }
    var value : Int {
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
    var p : String {
        get {
            self._p
        }
        set {
            self._p = newValue
        }
    }
    
    // Swift 5.1, can sluff the above off into a property wrapper
    @Facade()
    var p2 : String
    
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
    
    @Clamped(min:-7, max:7) var ppp : Int
    @Clamped() var pppp : Int {
        didSet { // proving they are allowed to have observers (but not always: see @State)
            print("did")
        }
        willSet {
            print("will")
        }
    }
    
    @State var ppppp : Int = 0 {
        didSet {} // doesn't crash, so why does it crash in a real SwiftUI project?
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
        
        self.p2 = "hi"
        print(self.p2)
        print("dollar", $p2) // the struct

        self.pp = 5
        print(self.pp)
        self.pp = 20
        print(self.pp)
        self.pp = -10
        print(self.pp)
        
        self.ppp = 5
        print(self.ppp)
        self.ppp = 20
        print(self.ppp)
        self.ppp = -10
        print(self.ppp)
        
        print("dollar", $ppp)
        
        self.pppp = 5
        print(self.pppp)
        self.pppp = 20
        print(self.pppp)
        self.pppp = -10
        print(self.pppp)
        
        print("dollar", $pppp)


    
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

