

import UIKit

// @property (nullable, assign) id<NSCacheDelegate> delegate;


// to test, first reset simulator's content and settings

class MyDelegate : NSObject, NSCacheDelegate {
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        print("okay")
    }
}

class ViewController: UIViewController {
    
    var cache = NSCache<NSString,NSData>()
    var del : MyDelegate! = MyDelegate()

    @IBAction func doButton1(_ sender: Any) {
        self.cache.delegate = self.del
        self.cache.setObject(NSData(), forKey: "test")
    }
    
    let crash = true
    
    @IBAction func doButton2(_ sender: Any) {
        if crash {
            self.del = nil
            self.cache.removeAllObjects()
        }
    }

}

