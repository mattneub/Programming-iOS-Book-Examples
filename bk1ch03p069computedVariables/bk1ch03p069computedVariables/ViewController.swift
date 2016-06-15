

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



class ViewController: UIViewController {
    
    var mp : MPMusicPlayerController {
        return MPMusicPlayerController.systemMusicPlayer()
    }

    
    // typical "facade" structure
    private var _p : String = ""
    var p : String {
        get {
            return self._p
        }
        set {
            self._p = newValue
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

    
    
        now = "Howdy"
        print(now)
        
        self.s = "Hello"
        self.s = "Bonjour"

    
    
    }
    
    private var myBigDataReal : Data! = nil
    var myBigData : Data! {
        set (newdata) {
            self.myBigDataReal = newdata
        }
        get {
            if myBigDataReal == nil {
                let fm = FileManager()
                let f = try! URL.init(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("myBigData")
                if let d = try? Data(contentsOf:f) {
                    print("loaded big data from disk")
                    self.myBigDataReal = d
                    do {
                        try fm.removeItem(at:f)
                        print("deleted big data from disk")
                    } catch {
                        print("Couldn't remove temp file")
                    }
                }
            }
            return self.myBigDataReal
        }
    }



}

