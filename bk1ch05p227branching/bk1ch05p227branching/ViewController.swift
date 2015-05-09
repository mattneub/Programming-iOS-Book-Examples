

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    var selectedTile : UIView!
    var player : AVPlayer!
    
    var progress = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = UIView()
        if self.selectedTile != nil { // artificial stubbing to illustrate code from one of my apps
            
            
            // okay, we've tapped a tile; there are three cases
            if self.selectedTile == nil { // no other selected tile: select and play
                self.selectTile(v)
                let url = v.layer.valueForKey("song") as! NSURL
                let item = AVPlayerItem(URL:url)
                self.player = AVPlayer(playerItem:item)
                self.player!.play()
            } else if self.selectedTile == v { // selected tile was tapped: deselect
                self.deselectAll()
            } else { // there was one selected tile and another was tapped: swap
                let v1 = self.selectedTile!
                self.selectedTile = nil
                let v2 = v
                self.swap(v1, with:v2, check:true, fence:true)
            }
            
        }
        
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "notificationArrived:", name: "test", object: nil)
        nc.postNotificationName("test", object: self, userInfo: ["junk":"nonsense"])
        nc.postNotificationName("test", object: self, userInfo: ["progress":"nonsense"])
        nc.postNotificationName("test", object: self, userInfo: ["progress":3])
    }
    
    func notificationArrived(n:NSNotification) {
        let prog = n.userInfo?["progress"] as? NSNumber
        if prog != nil {
            self.progress = prog!.doubleValue
        }
        
        if let ui = n.userInfo {
            if let prog : AnyObject = ui["progress"] {
                if prog is NSNumber {
                    self.progress = (prog as! NSNumber).doubleValue
                }
            }
        }
        
        if let ui = n.userInfo {
            if let prog = ui["progress"] as? NSNumber {
                self.progress = prog.doubleValue
            }
        }
        
        // these will also be repeated in chapter 10
        
        if let ui = n.userInfo {
            if let prog = ui["progress"] as? Double {
                self.progress = prog
            }
        }
        
        if let ui = n.userInfo, prog = ui["progress"] as? Double {
            self.progress = prog
        }

    }

    
    // stubs, ignore
    func selectTile(v:UIView) {}
    func deselectAll() {}
    func swap(v1:UIView, with v2:UIView, check:Bool, fence:Bool) {}


}

class C1 : NSObject {
    override func observeValueForKeyPath(keyPath: String,
        ofObject object: AnyObject, change: [NSObject : AnyObject],
        context: UnsafeMutablePointer<()>) {
            if keyPath == "readyForDisplay" {
                if let obj = object as? AVPlayerViewController {
                    if let ok = change[NSKeyValueChangeNewKey] as? Bool {
                        if ok {
                            // ...
                        }
                    }
                }
            }
    }
}

class C2 : NSObject {
    override func observeValueForKeyPath(keyPath: String,
        ofObject object: AnyObject, change: [NSObject : AnyObject],
        context: UnsafeMutablePointer<()>) {
            if keyPath == "readyForDisplay",
                let obj = object as? AVPlayerViewController,
                let ok = change[NSKeyValueChangeNewKey] as? Bool where ok {
                    // ...
            }
    }
}

