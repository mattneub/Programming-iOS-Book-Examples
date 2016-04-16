
import UIKit
import MediaPlayer

let which = 1 // 1 or 2

class ViewController: UIViewController {
    
    var observers = Set<NSObject>()
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.singleTap(self)
        
        let mp = MPMusicPlayerController.systemMusicPlayer()
        mp.beginGeneratingPlaybackNotifications()
        
        switch which {
        case 1:
            
            NSNotificationCenter.default().addObserver(self,
                selector: #selector(nowPlayingItemChanged),
                name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
                object: nil)
            
        case 2:
            
            let ob = NSNotificationCenter.default()
                .addObserver(forName:
                    MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
                    object: nil, queue: nil) {
                        _ in
                        print("changed")
            }
            self.observers.insert(ob as! NSObject)

            
        default:break
        }
        
    }
    
    func nowPlayingItemChanged (_ n:NSNotification) {
        print("changed")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch which {
        case 1:
            
            NSNotificationCenter.default().removeObserver(self)
            
        case 2:
            
            for ob in self.observers {
                NSNotificationCenter.default().removeObserver(ob)
            }
            self.observers.removeAll()
            
        default:break
        }
        
        let mp = MPMusicPlayerController.systemMusicPlayer()
        mp.endGeneratingPlaybackNotifications()
    }
    
    func singleTap(_:AnyObject) {
        NSNotificationCenter.default()
            .post(name: "cardTapped", object: self)
    }



}

