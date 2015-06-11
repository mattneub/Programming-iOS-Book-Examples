
import UIKit
import MediaPlayer

let which = 2 // 1 or 2

class ViewController: UIViewController {
    
    var observers = Set<NSObject>()

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        self.singleTap(self)
        
        let mp = MPMusicPlayerController.systemMusicPlayer()
        mp.beginGeneratingPlaybackNotifications()
        
        switch which {
        case 1:
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "nowPlayingItemChanged:",
                name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
                object: nil)
            
        case 2:
            
            let ob = NSNotificationCenter.defaultCenter()
                .addObserverForName(
                    MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
                    object: nil, queue: nil) {
                        _ in
                        println("changed")
            }
            self.observers.insert(ob as! NSObject)

            
        default:break
        }
        
    }
    
    func nowPlayingItemChanged (n:NSNotification) {
        println("changed")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch which {
        case 1:
            
            NSNotificationCenter.defaultCenter().removeObserver(self)
            
        case 2:
            
            for ob in self.observers {
                NSNotificationCenter.defaultCenter().removeObserver(ob)
            }
            self.observers.removeAll()
            
        default:break
        }
        
        let mp = MPMusicPlayerController.systemMusicPlayer()
        mp.endGeneratingPlaybackNotifications()
    }
    
    func singleTap(_:AnyObject) { // select me
        NSNotificationCenter.defaultCenter()
        .postNotificationName("cardTapped", object: self)
    }



}

