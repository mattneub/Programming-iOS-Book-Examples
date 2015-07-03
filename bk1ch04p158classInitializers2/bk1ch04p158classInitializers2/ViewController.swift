
import UIKit


class LabelBarButtonItem: UIBarButtonItem {
    init(text: String) {
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        super.init() // this is now the only designated initializer
        self.customView = label
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class Dog {
    var name : String
    required init(name:String) {
        self.name = name
    }
}
class NoisyDog : Dog {
    var obedient = false
    init(obedient:Bool) {
        self.obedient = obedient
        super.init(name:"Fido")
    }
    // without this override, NoisyDog won't compile
    required init(name:String) {
        super.init(name:name)
    }
}



class ViewController: UIViewController {
    
    @IBOutlet var toolbar : UIToolbar!
    
    init() {
        super.init(nibName:"MyNib", bundle:nil)
    }
    
    // without this override, AppDelegate won't compile:
    
    override init(nibName: String?, bundle: NSBundle?) {
        super.init(nibName:nibName, bundle:bundle)
    }

    // without _this_ override, ViewController won't compile:

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let lbbi = LabelBarButtonItem(text:"Howdy")  // crashing bug in iOS 8 fixed in iOS 9
        _ = lbbi
        self.toolbar.items = [lbbi]
        
        class MyBezierPath : UIBezierPath {}
        let b = MyBezierPath(rect:CGRectZero) // bug in iOS 8 fixed in iOS 9
        _ = b
        
    }

    @IBAction func doButton (sender:AnyObject!) {
        let tvc = MyTableViewController(greeting:"Hello there")
        self.presentViewController(tvc, animated: true, completion: nil)
        // crashing bug in iOS 8 fixed in iOS 9;
        // it is now okay once again to subclass UITableViewController and instantiate it manually
    }



}

