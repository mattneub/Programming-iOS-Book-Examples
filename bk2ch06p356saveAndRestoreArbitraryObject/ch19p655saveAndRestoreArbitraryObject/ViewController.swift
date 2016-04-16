
import UIKit

class ViewController : UIViewController {
    
    var thing : Thing!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thing = self.dynamicType.makeThing()
    }
    
    // This is not being called, and I don't know why
    // as a result, the example is not working
    
    @objc(encodeRestorableStateWithCoder:)
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with:coder)
        coder.encode(self.thing, forKey: "mything") // must show this object to the archiver
    }
    
    override func applicationFinishedRestoringState() {
        print("finished view controller")
        // self.thing.restorationParent = self
    }
    
    @IBAction func doRead(_ sender:AnyObject?) {
        let alert = UIAlertController(title: "Read", message: self.thing.word, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style:.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
        
    @IBAction func doWrite(_ sender:AnyObject?) {
        let alert = UIAlertController(title: "Write", message: nil, preferredStyle: .alert)
        alert.addTextField { tf in tf.text = self.thing.word }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            _ in
            self.thing.word = alert.textFields![0].text!
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        print("farewell")
    }
    
}

extension ViewController : UIObjectRestoration {
    
    class func makeThing () -> Thing {
        let thing = Thing()
        UIApplication.registerObject(forStateRestoration: thing, restorationIdentifier: "thing")
        // thing.objectRestorationClass = self
        return thing
    }
    
    // unused, no actual restoration, just showing it can be done
    class func object(withRestorationIdentifierPath ip: [String],
        coder: NSCoder) -> UIStateRestoring? {
            print(ip)
            let thing = self.makeThing()
            return thing
    }
    
}