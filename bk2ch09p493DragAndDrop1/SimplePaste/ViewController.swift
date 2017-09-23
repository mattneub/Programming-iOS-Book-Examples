

import UIKit

class DropView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pasteConfiguration = UIPasteConfiguration(forAccepting: UIColor.self)
    }
    override func paste(itemProviders: [NSItemProvider]) {
        for ip in itemProviders {
            ip.loadObject(ofClass: UIColor.self) { (color, error) in
                if let color = color {
                    print(color)
                    print(Thread.isMainThread) // false
                }
            }
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var dropView: UIView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dragger = UIDragInteraction(delegate: self)
        self.redView.addInteraction(dragger)
        
        self.button.isSpringLoaded = true // mostly buttons and button-like things, and table/collection views
        self.button.addInteraction(UISpringLoadedInteraction() { (int, con) in
            // there are two initializers; this is the simplest one, with just an activation handler
            // the button will sort of flash and fire this method
            // it won't also automatically fire its main control event; that's up to you
            print("button")
        })
    }
    @IBAction func doButton(_ sender: Any) {
        print("do button")
    }
}

extension ViewController : UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let ip = NSItemProvider(object:UIColor.red)
        let di = UIDragItem(itemProvider: ip)
        return [di]
    }
}

