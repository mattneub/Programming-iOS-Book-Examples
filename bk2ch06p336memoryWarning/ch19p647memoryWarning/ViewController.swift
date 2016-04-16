
import UIKit
import Foundation

@objc protocol Dummy {
    func _performMemoryWarning() // shut the compiler up
}

class ViewController : UIViewController {
    
    // ignore; just making sure it compiles
    
    // NSCache now comes across as a true Swift generic!
    // so you have to resolve those generics explicitly
    // feels like a bug to me, but whatever
    
    let cache = NSCache<NSString, AnyObject>()
    var cachedData : NSData {
        let key = "somekey" as NSString
        var data = self.cache.object(forKey:key) as? NSData
        if data != nil {
            return data!
        }
        // ... recreate data here ...
        data = NSData() // recreated data
        self.cache.setObject(data!, forKey: key)
        return data!
    }
    
    var purgeable = NSPurgeableData()
    var purgeabledata : NSData {
        // surprisingly tricky to get content access barriers correct
        if self.purgeable.beginContentAccess() && self.purgeable.length > 0 {
            let result = self.purgeable.copy() as! NSData
            self.purgeable.endContentAccess()
            return result
        } else {
            // ... recreate data here ...
            let data = NSData() // recreated data
            self.purgeable = NSPurgeableData(data:data)
            self.purgeable.endContentAccess() // must call "end"!
            return data
        }
    }
    

    // this is the actual example
    
    private var myBigDataReal : NSData! = nil
    var myBigData : NSData! {
        set (newdata) {
            self.myBigDataReal = newdata
        }
        get {
            if myBigDataReal == nil {
                let fm = NSFileManager()
                let f = (NSTemporaryDirectory() as NSString).appendingPathComponent("myBigData")
                if fm.fileExists(atPath:f) {
                    print("loading big data from disk")
                    self.myBigDataReal = NSData(contentsOfFile: f)
                    do {
                        try fm.removeItem(atPath:f)
                        print("deleted big data from disk")
                    } catch {
                        print("Couldn't remove temp file")
                    }
                }
            }
            return self.myBigDataReal
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // wow, this is some big data!
        self.myBigData = "howdy".data(using:NSUTF8StringEncoding, allowLossyConversion: false)
    }
    
    // tap button to prove we've got big data
    
    @IBAction func doButton (_ sender:AnyObject?) {
        let s = NSString(data: self.myBigData, encoding: NSUTF8StringEncoding) as! String
        let av = UIAlertController(title: "Got big data, and it says:", message: s, preferredStyle: .alert)
        av.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(av, animated: true, completion: nil)
    }
    
    // to test, run the app in the simulator and trigger a memory warning
    
    func saveAndReleaseMyBigData() {
        if let myBigData = self.myBigData {
            print("unloading big data")
            let f = (NSTemporaryDirectory() as NSString).appendingPathComponent("myBigData")
            myBigData.write(toFile:f, atomically:false)
            self.myBigData = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        print("did receive memory warning")
        super.didReceiveMemoryWarning()
        self.saveAndReleaseMyBigData()
    }
    
    deinit {
        NSNotificationCenter.default().removeObserver(self)
    }
    
    // on device
    
    // ignore compiler warning, it's private API (you'd have to remove it from shipping code)
    
    @IBAction func doButton2(_ sender: AnyObject) {
        UIApplication.shared().perform(#selector(Dummy._performMemoryWarning))
    }
    
    // backgrounding
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.default().addObserver(self, selector: #selector(backgrounding), name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    func backgrounding(n:NSNotification) {
        self.saveAndReleaseMyBigData()
    }
    
}
