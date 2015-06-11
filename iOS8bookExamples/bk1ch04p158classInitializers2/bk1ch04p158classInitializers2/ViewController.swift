
import UIKit

class LabelBarButtonItem: UIBarButtonItem {
    init(text: String) {
        let label = UILabel()
        label.text = text
        super.init(customView: label)
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

        let lbbi = LabelBarButtonItem(text:"Howdy")  // crash!

    }



}

