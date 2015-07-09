

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    var selectedTile : UIView!
    var player : AVPlayer!
    
    var progress = 0.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tile = UIView()
        if self.selectedTile != nil { // artificial stubbing to illustrate code from one of my apps
            
            
            // okay, we've tapped a tile; there are three cases
            if self.selectedTile == nil { // no selected tile: select and play this tile
                self.selectTile(tile)
                self.playTile(tile)
            } else if self.selectedTile == tile { // selected tile was tapped: deselect it and stop playing it
                self.deselectAll()
                self.player?.pause()
            } else { // there was a selected tile, and another tile was tapped: swap them
                self.swap(self.selectedTile, with:tile, check:true, fence:true)
            }
            
            // using new Swift 2.0 optional unwrapping switch, we can also say it this way:
            
            switch self.selectedTile { // use interesting new Swift 2.0 unwrapping syntax
            case nil: // no selected tile: select and play this tile
                self.selectTile(tile)
                self.playTile(tile)
            case tile?: // selected tile was tapped: deselect it and stop playing it
                self.deselectAll()
                self.player?.pause()
            case let tile2?: // there was a selected tile, and another tile was tapped: swap them
                self.swap(tile2, with:tile, check:true, fence:true)
            }
            
        }
        
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "notificationArrived:", name: "test", object: nil)
        nc.postNotificationName("test", object: self, userInfo: ["junk":"nonsense"])
        nc.postNotificationName("test", object: self, userInfo: ["progress":"nonsense"])
        nc.postNotificationName("test", object: self, userInfo: ["progress":3])
    }
    
    func notificationArrived(n:NSNotification) {
        do {
            let prog = n.userInfo?["progress"] as? NSNumber
            if prog != nil {
                self.progress = prog!.doubleValue
            }
        }
        
        do {
            let prog = (n.userInfo?["progress"] as? NSNumber)?.doubleValue
            if prog != nil {
                self.progress = prog!
            }
        }
        
        if let prog = (n.userInfo?["progress"] as? NSNumber)?.doubleValue {
            self.progress = prog
        }

        // chapter 10
        if let prog = n.userInfo?["progress"] as? Double {
            self.progress = prog
        }


        if let ui = n.userInfo {
            if let prog : AnyObject = ui["progress"] {
                if let prog = prog as? NSNumber {
                    self.progress = prog.doubleValue
                }
            }
        }
        
        if let ui = n.userInfo {
            if let prog = ui["progress"] as? NSNumber {
                self.progress = prog.doubleValue
            }
        }
        
        if let ui = n.userInfo, prog = ui["progress"] as? NSNumber {
            self.progress = prog.doubleValue
        }
        

    }

    
    // stubs, ignore
    func selectTile(v:UIView) {}
    func deselectAll() {}
    func swap(v1:UIView, with v2:UIView, check:Bool, fence:Bool) {}
    func playTile (tile:UIView) {}


}

class C1 : NSObject {
    override func observeValueForKeyPath(keyPath: String?,
        ofObject object: AnyObject?, change: [String : AnyObject]?,
        context: UnsafeMutablePointer<()>) {
            if keyPath == "readyForDisplay" {
                if let obj = object as? AVPlayerViewController {
                    if let ok = change?[NSKeyValueChangeNewKey] as? Bool {
                        if ok {
                            // ...
                            print(obj)
                        }
                    }
                }
            }
    }
}

class C2 : NSObject {
    override func observeValueForKeyPath(keyPath: String?,
        ofObject object: AnyObject?, change: [String : AnyObject]?,
        context: UnsafeMutablePointer<()>) {
            if keyPath == "readyForDisplay",
                let obj = object as? AVPlayerViewController,
                let ok = change?[NSKeyValueChangeNewKey] as? Bool where ok {
                    // ...
                    print(obj)
            }
    }
}

class C3 : NSObject {
    override func observeValueForKeyPath(keyPath: String?,
        ofObject object: AnyObject?, change: [String : AnyObject]?,
        context: UnsafeMutablePointer<()>) {
            guard keyPath == "readyForDisplay" else {return}
            guard let obj = object as? AVPlayerViewController else {return}
            guard let ok = change?[NSKeyValueChangeNewKey] as? Bool else {return}
            guard ok else {return}
            // ...
            print(obj)
    }

}

