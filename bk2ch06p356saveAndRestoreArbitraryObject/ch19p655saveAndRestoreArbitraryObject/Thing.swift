

import UIKit

class Thing : NSObject, UIStateRestoring {
    
    var word = ""
    
    var restorationParent: UIStateRestoring? // unused
    
    var objectRestorationClass: AnyObject.Type? // unused
    
    @objc(encodeRestorableStateWithCoder:)
    func encodeRestorableState(with coder: NSCoder) {
        print("thing encode")
        coder.encode(self.word, forKey:"word")
    }
    
    @objc(decodeRestorableStateWithCoder:)
    func decodeRestorableState(with coder: NSCoder) {
        print("thing decode")
        self.word = coder.decodeObject(forKey:"word") as! String
    }
    
    func applicationFinishedRestoringState() {
        print("finished thing")
    }
    
    
}
