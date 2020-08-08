

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var longButton: UIButton!
    
    @IBOutlet weak var tapBBI: UIBarButtonItem!
    @IBOutlet weak var longBBI: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func makeMenu() -> UIMenu {
            let action = UIAction(title: "Howdy") { action in
                print("Howdy")
            }
            let menu = UIMenu(title: "", children: [action])
            return menu
        }
        
        // for a button, the menu is long press by default
        self.longButton.menu = makeMenu()
        // so if you want it to be tap, you must say so
        self.tapButton.menu = makeMenu()
        self.tapButton.showsMenuAsPrimaryAction = true
        
        // but a bar button item is the other way round! It is tap by default
        self.tapBBI.menu = makeMenu()
        // if you want it long press, you must supply a target-action or primaryAction
        self.longBBI.menu = makeMenu()
        // NB the title in the primary action becomes the title of the button!
        // so if you omit the title, the title goes blank
        // similarly if you supply an image, it becomes the image of the button
        var prim : Bool { true }
        if prim {
            let im = UIImage(systemName: "circle")!
            // try changing the image to im
            self.longBBI.primaryAction = UIAction(title: "Long", image: nil) { action in }
            // self.longBBI.title = "Aha" // yep
        } else {
            self.longBBI.target = self
            self.longBBI.action = #selector(tap)
        }
    }
    
    @objc func tap() {
        print("tap")
    }


}

