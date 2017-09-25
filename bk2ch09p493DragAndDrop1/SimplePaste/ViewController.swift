

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
    var doInstallation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !self.doInstallation {
            self.view.backgroundColor = .green
            self.button.setTitle("Back", for: .normal)
            return
        }
        
        let dragger = UIDragInteraction(delegate: self)
        dragger.isEnabled = true // for iPhone
        self.redView.addInteraction(dragger)
        
        self.button.isSpringLoaded = true // mostly buttons and button-like things, and table/collection views
        self.button.addInteraction(UISpringLoadedInteraction() { int, con in
            // there are two initializers; this is the simplest one, with just an activation handler
            // the button will sort of flash and fire this method
            // it won't also automatically fire its main control event; that's up to you
            
            /*
            // just as I thought; a spring loaded alert has spring loaded buttons
            let alert = UIAlertController(title: "testing", message: "testing", preferredStyle: .alert)
            alert.isSpringLoaded = true
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return;
            */
            
            let vc = self.storyboard!.instantiateInitialViewController() as! ViewController
            vc.modalTransitionStyle = .flipHorizontal
            vc.doInstallation = false
            self.present(vc, animated: true)
        })
    }
    
    @IBAction func doButton(_ sender: Any) {
        print("do button")
        self.dismiss(animated: true)
    }
}

extension ViewController : UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let ip = NSItemProvider(object:UIColor.red)
        let di = UIDragItem(itemProvider: ip)
        return [di]
    }
}

