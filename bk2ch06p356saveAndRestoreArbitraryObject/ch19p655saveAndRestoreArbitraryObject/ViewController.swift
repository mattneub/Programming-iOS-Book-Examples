
import UIKit

class ViewController : UIViewController {
    
    var thing : Thing!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thing = self.dynamicType.makeThing()
    }
    
    override func encodeRestorableStateWithCoder(coder: NSCoder!) {
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
    
    // as of this writing there's a bug where we don't see the keyboard or the 
    // alert view itself is truncated: seems to be fixed in seed 4
    
    @IBAction func doWrite(sender:AnyObject?) {
        let alert = UIAlertController(title: "Write", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ tf in tf.text = self.thing.word })
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            _ in
            self.thing.word = (alert.textFields[0] as UITextField).text
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
    
    class func objectWithRestorationIdentifierPath(ip: [AnyObject]!,
        coder: NSCoder!) -> UIStateRestoring! {
            println(ip)
            return self.makeThing()
    }
    
}