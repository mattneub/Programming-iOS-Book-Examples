

import UIKit

class Pep: UIViewController {
    
    let boy : String
    @IBOutlet var name : UILabel!
    @IBOutlet var pic : UIImageView!
    
    override var previewActionItems: [UIPreviewActionItem] {
        // example of submenu (group)
        let col1 = UIPreviewAction(title:"Blue", style: .default) {
            action, vc in print ("coloring this pep boy", action.title.lowercased())
        }
        let col2 = UIPreviewAction(title:"Green", style: .default) {
            action, vc in print ("coloring this pep boy", action.title.lowercased())
        }
        let col3 = UIPreviewAction(title:"Red", style: .default) {
            action, vc in print ("coloring this pep boy", action.title.lowercased())
        }
        let group = UIPreviewActionGroup(title: "Colorize", style: .default, actions: [col1, col2, col3])
        // example of selected style
        let favKey = "favoritePepBoy"
        let style : UIPreviewAction.Style =
            self.boy == UserDefaults.standard.string(forKey:favKey) ? .selected : .default
        let fav = UIPreviewAction(title: "Favorite", style: style) {
            action, vc in
            if let pep = vc as? Pep {
                // make this pep boy favorite
                print("\(pep.boy) is now your favorite")
                UserDefaults.standard.set(pep.boy, forKey:favKey)
            }
        }
        return [group, fav]
    }
    
    init(pepBoy boy:String) {
        self.boy = boy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = self.boy
        self.pic.image = UIImage(named:"\(self.boy.lowercased())")
    }
    
    override var description : String {
    return self.boy
    }
    


}
