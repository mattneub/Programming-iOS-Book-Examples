

import UIKit

class PepEditorViewController: UIViewController {
    
    @IBOutlet var pepContainer : UIView!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    var restorationInfo :  [AnyHashable : Any]?
    
    var pepName : String = "Manny"
    
    static let editingRestorationKey = "editing"
    static let isFavoriteRestorationKey = "favorite"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pep = Pep(pepBoy: pepName)
        
        pep.view.frame = self.pepContainer.bounds
        self.pepContainer.addSubview(pep.view)
        pep.didMove(toParent: self)
        
        let key = Self.isFavoriteRestorationKey
        let info = self.restorationInfo
        print("pep editor view did load", info as Any)
        if let fav = info?[key] as? Bool {
            self.favoriteSwitch.isOn = fav
        }
        
        
    }
    
    
    // boilerplate
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.userActivity = self.view.window?.windowScene?.userActivity
        self.restorationInfo = nil

    }
        
    override func updateUserActivityState(_ activity: NSUserActivity) {
        super.updateUserActivityState(activity)
        print("pep editor update user activity state")
        let key = Self.editingRestorationKey
        activity.addUserInfoEntries(from: [key:true])
        let key2 = Self.isFavoriteRestorationKey
        activity.addUserInfoEntries(from: [key2:self.favoriteSwitch.isOn])
        print(activity.userInfo as Any)
    }

    // can also store stuff in the session's userInfo
    // and this persists while the session persists, which could be enough
    // but of course if we make another window it might have a different session

    
}
