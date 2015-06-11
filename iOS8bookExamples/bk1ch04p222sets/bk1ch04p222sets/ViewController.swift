

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let set : Set<Int> = [1, 2, 3, 4, 5]
        
        let arr = [1,2,1,3,2,4,3,5]
        let set2 = Set(arr)
        let arr2 = Array(set2) // [5,2,3,1,4] perhaps

        let set3 : Set = [1,2,3,4,5]
        let set4 = Set(map(set3) {$0+1}) // {6, 5, 2, 3, 4}, perhaps

        let types : UIUserNotificationType = .Alert | .Sound
        let category = UIMutableUserNotificationCategory()
        category.identifier = "coffee"
        // ...
        let categories = Set([category])
        let settings = UIUserNotificationSettings(forTypes: types, categories: categories)

    }

    override func touchesBegan(
        touches: Set<NSObject>, withEvent event: UIEvent) {
            let set = touches as! Set<UITouch>
            // ...
    }



}

