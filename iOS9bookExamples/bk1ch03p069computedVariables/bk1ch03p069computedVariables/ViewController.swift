

import UIKit
import MediaPlayer

var now : String {
    get {
        return NSDate().description
    }
    set {
        print(newValue)
    }
}

var now2 : String { // showing you can omit "get" if there is no "set"
    return NSDate().description
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
    
    private var myBigDataReal : NSData! = nil
    var myBigData : NSData! {
        set (newdata) {
            self.myBigDataReal = newdata
        }
        get {
            if myBigDataReal == nil {
                let fm = NSFileManager()
                let f = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("myBigData")
                if fm.fileExistsAtPath(f) {
                    print("loading big data from disk")
                    self.myBigDataReal = NSData(contentsOfFile: f)
                    do {
                        try fm.removeItemAtPath(f)
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

