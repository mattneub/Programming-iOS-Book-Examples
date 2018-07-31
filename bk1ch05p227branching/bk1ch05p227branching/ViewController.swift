

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
                self.select(tile:tile)
                self.play(tile:tile)
            } else if self.selectedTile == tile { // selected tile was tapped: deselect it and stop playing it
                self.deselectAll()
                self.player?.pause()
            } else { // there was a selected tile, and another tile was tapped: swap them
                self.swap(self.selectedTile, with:tile, check:true, fence:true)
            }
            
            // using new Swift 2.0 optional unwrapping switch, we can also say it this way:
            
            switch self.selectedTile { // use interesting new Swift 2.0 unwrapping syntax
            case nil: // no selected tile: select and play this tile
                self.select(tile:tile)
                self.play(tile:tile)
            case tile?: // selected tile was tapped: deselect it and stop playing it
                self.deselectAll()
                self.player?.pause()
            case let tile2?: // there was a selected tile, and another tile was tapped: swap them
                self.swap(tile2, with:tile, check:true, fence:true)
            }
            
        }
        
        
        let nc = NotificationCenter.default
        // let test = "test" as Notification.Name
        let test = Notification.Name("test")
        nc.addObserver(self, selector: #selector(notificationArrived), name:test, object: nil)
        nc.post(name:test, object: self, userInfo: ["junk":"nonsense"])
        nc.post(name:test, object: self, userInfo: ["progress":"nonsense"])
        nc.post(name:test, object: self, userInfo: ["progress":3])
    }
    
    @objc func notificationArrived(_ n:Notification) {
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

        // chapter 10, but I'm moving this up to chapter 5
        if let prog = n.userInfo?["progress"] as? Double {
            self.progress = prog
        }

        
        if let ui = n.userInfo {
            if let prog = ui["progress"] as? NSNumber {
                self.progress = prog.doubleValue
            }
        }
        
        if let ui = n.userInfo {
            if let prog = ui["progress"] as? NSNumber {
                self.progress = prog.doubleValue
            }
        }
        
        if let ui = n.userInfo {
            if let prog = ui["progress"] as? Double {
                self.progress = prog
            }
        }

        
        if let ui = n.userInfo, let prog = ui["progress"] as? NSNumber {
            self.progress = prog.doubleValue
        }
        
        if let ui = n.userInfo, let prog = ui["progress"] as? Double {
            self.progress = prog
        }
        
        if let ui = n.userInfo, let prog = ui["progress"], prog is Double {
            self.progress = prog as! Double
        }

        do {
            guard let ui = n.userInfo else {return}
            guard let prog = ui["progress"] as? Double else {return}
            self.progress = prog
        }

        
        print(n)

    }

    
    // stubs, ignore
    func select(tile:UIView) {}
    func deselectAll() {}
    func swap(_ v1:UIView, with v2:UIView, check:Bool, fence:Bool) {}
    func play(tile:UIView) {}


}

// NOTE! In Swift 4, all this changes: new key path syntax, new KVO syntax

// let readyForDisplay = #keyPath(AVPlayerViewController.readyForDisplay)

/*

// func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)

class C1 : NSObject {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == readyForDisplay {
                if let obj = object as? AVPlayerViewController {
                    if let ok = change?[.newKey] as? Bool {
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
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == readyForDisplay,
                let obj = object as? AVPlayerViewController,
                let ok = change?[.newKey] as? Bool,
                ok {
                    // ...
                    print(obj)
            }
    }
}

class C3 : NSObject {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            guard keyPath == readyForDisplay else {return}
            guard let obj = object as? AVPlayerViewController else {return}
            guard let ok = change?[.newKey] as? Bool else {return}
            guard ok else {return}
            // ...
            print(obj)
    }
}

// this is legal, but I don't see its advantage over the C2 form and I don't mention it in the book:

class C4 : NSObject {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == readyForDisplay,
        let obj = object as? AVPlayerViewController,
        let ok = change?[.newKey] as? Bool,
        ok else {return}
        // ...
        print(obj)
    }
}

 */

// this shows why the whole example largely falls
// the only thing now worth testing is the change object
// there's little doubt what the object would be

class C1 : NSObject {
    let avpvc = AVPlayerViewController()
    func test() {
        let obs = self.avpvc.observe(\.isReadyForDisplay, options:[.new]) { (obj, ch) in
            if let ok = ch.newValue, ok {
                // do work here ...
                // obs.invalidate() // illegal, but we also get a warning if we don't capture the result
            }
        }
        obs.invalidate() // probably if we do this we'll never even get the notification
    }
}

// ... though I _suppose_ can imagine passing multiple calls thru the same code in which case we'd test the object too
// but then wouldn't that make the whole closure-based structure pointless?


