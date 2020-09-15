
import UIKit
import Foundation

@objc protocol Dummy {
    func _performMemoryWarning() // shut the compiler up
}

class ViewController : UIViewController {
    
    // NSCache now comes across as a true Swift generic!
    // so you have to resolve those generics explicitly
    // feels like a bug to me, but whatever
    // uses AnyObject, not Any, so we are forced to cross the bridge explicitly
    
    private let _cache = NSCache<NSString, NSData>()
    var cachedData : Data {
        let key = "somekey" as NSString
        if let olddata = self._cache.object(forKey:key) {
            return olddata as Data
        }
        // ... recreate data here ...
        print("recreating data for cache")
        let newdata = Data([1,2,3,4]) // recreated data
        self._cache.setObject(newdata as NSData, forKey: key)
        return newdata
    }
    
    private var _purgeable = NSPurgeableData()
    var purgeabledata : Data {
        // surprisingly tricky to get content access barriers correct
        if self._purgeable.beginContentAccess() && self._purgeable.length > 0 {
            let result = self._purgeable.copy() as! Data
            self._purgeable.endContentAccess()
            return result
        } else {
            // ... recreate data here ...
            print("recreating data for purgeable")
            let data = Data([6,7,8,9]) // recreated data
            self._purgeable = NSPurgeableData(data:data)
            self._purgeable.endContentAccess() // must call "end"!
            return data
        }
    }
        
    // this is the actual example
    private let fnam = "myBigData"
    private var _myBigData : Data! = nil
    var myBigData : Data! {
        set (newdata) { self._myBigData = newdata }
        get {
            if _myBigData == nil {
                let fm = FileManager.default
                let f = fm.temporaryDirectory.appendingPathComponent(self.fnam)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // wow, this is some big data!
        self.myBigData = "howdy".data(using:.utf8, allowLossyConversion: false)
    }
    
    // tap button to prove we've got big data
    
    @IBAction func doButton (_ sender: Any?) {
        let s = String(data: self.myBigData, encoding:.utf8)
        let av = UIAlertController(title: "Got big data, and it says:", message: s, preferredStyle: .alert)
        av.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(av, animated: true)
    }
    
    // to test, run the app in the simulator and trigger a memory warning
    
    func saveAndReleaseMyBigData() {
        if let myBigData = self.myBigData {
            print("unloading big data")
            let fm = FileManager.default
            let f = fm.temporaryDirectory.appendingPathComponent(self.fnam)
            if let _ = try? myBigData.write(to:f) {
                print("resetting big data in memory")
                self.myBigData = nil
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        print("did receive memory warning")
        super.didReceiveMemoryWarning()
        self.saveAndReleaseMyBigData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // on device
    // private API (you'd have to remove it from shipping code)
    
    @IBAction func doButton2(_ sender: Any) {
        UIApplication.shared.perform(#selector(Dummy._performMemoryWarning))
        self._purgeable.discardContentIfPossible()
    }
    
    @IBAction func testCaches(_ sender: Any) {
        print(self.cachedData)
        print(self.purgeabledata)
    }
    // backgrounding
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var didAppearInitially = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didAppearInitially {
            didAppearInitially = true
            if #available(iOS 13.0, *) {
                let scene = self.view.window?.windowScene
                NotificationCenter.default.addObserver(self, selector: #selector(backgrounding), name: UIScene.didEnterBackgroundNotification, object: scene)
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(backgrounding), name: UIApplication.didEnterBackgroundNotification, object: nil)
            }
            NotificationCenter.default.addObserver(self, selector: #selector(memoryNotification), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)

        }
    }
    
    @objc func memoryNotification(_ n:Notification) {
        print("did receive memory notification")
    }
    
    @objc func backgrounding(_ n:Notification) {
        print("got did enter background notification")
        DispatchQueue.global().async {
            var ident = UIBackgroundTaskIdentifier.invalid
            print("starting background task")
            ident = UIApplication.shared.beginBackgroundTask {
                print("ending background task prematurely")
                UIApplication.shared.endBackgroundTask(ident)
            }
            self.saveAndReleaseMyBigData()
            print("ending background task")
            UIApplication.shared.endBackgroundTask(ident)
        }
    }
    
}
