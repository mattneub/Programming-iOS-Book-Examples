

import UIKit

class ViewController: UIViewController, UIDragInteractionDelegate {
    @IBOutlet weak var lab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let di = UIDragInteraction(delegate: self)
        di.isEnabled = true
        self.lab.addInteraction(di)
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard interaction.view === self.lab else { return [] }
        let p = Person(firstName: "Draggable", lastName: "Text")
        let ip = NSItemProvider(object: p)
        let di = UIDragItem(itemProvider: ip)
        di.localObject = p
        return [di]
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, sessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool {
        return true
    }
}
