
import UIKit

class ViewController : UIViewController {
    
    var thing : Thing!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thing = self.dynamicType.makeThing()
    }
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        super.encodeRestorableStateWithCoder(coder)
        coder.encodeObject(self.thing, forKey: "mything") // must show this object to the archiver
    }
    
    override func applicationFinishedRestoringState() {
        println("finished view controller")
        // self.thing.restorationParent = self
    }
    
    @IBAction func doRead(sender:AnyObject?) {
        let alert = UIAlertController(title: "Read", message: self.thing.word, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style:.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
        
    @IBAction func doWrite(sender:AnyObject?) {
        let alert = UIAlertController(title: "Write", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ tf in tf.text = self.thing.word })
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            _ in
            self.thing.word = (alert.textFields![0] as! UITextField).text
            }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

extension ViewController : UIObjectRestoration {
    
    class func makeThing () -> Thing {
        let thing = Thing()
        UIApplication.registerObjectForStateRestoration(thing, restorationIdentifier: "thing")
        // thing.objectRestorationClass = self
        return thing
    }
    
    // unused, no actual restoration, just showing it can be done
    class func objectWithRestorationIdentifierPath(ip: [AnyObject],
        coder: NSCoder) -> UIStateRestoring? {
            println(ip)
            let thing = self.makeThing()
            return thing
    }
    
}