

import UIKit

class Thing : NSObject, UIStateRestoring {
    
    var word = ""
    
    var restorationParent: UIStateRestoring? // unused
    
    var objectRestorationClass: AnyObject.Type? // unused
    
    func encodeRestorableStateWithCoder(coder: NSCoder) {
        print("thing encode")
        coder.encodeObject(self.word, forKey:"word")
    }
    
    func decodeRestorableStateWithCoder(coder: NSCoder) {
        print("thing decode")
        self.word = coder.decodeObjectForKey("word") as! String
    }
    
    func applicationFinishedRestoringState() {
        print("finished thing")
    }
    
    
}
