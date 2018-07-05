
import UIKit
import MediaPlayer

let which = 1 // 1 or 2

// right way to define a notification name


class Card {
    func singleTap(_: Any) {
        NotificationCenter.default
            .post(name: Card.tappedNotification, object: self)
    }
}
extension Card {
    static let tappedNotification = Notification.Name("cardTapped")
}


class ViewController: UIViewController {
    
    var observers = Set<NSObject>()
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Card().singleTap(self)
        
        let mp = MPMusicPlayerController.systemMusicPlayer
        mp.beginGeneratingPlaybackNotifications()
        
        switch which {
        case 1:
            
            NotificationCenter.default.addObserver(self,
                selector: #selector(nowPlayingItemChanged),
                name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                object: nil)
            
        case 2:
            
            let ob = NotificationCenter.default
                .addObserver(forName:
                    .MPMusicPlayerControllerNowPlayingItemDidChange,
                    object: nil, queue: nil) { _ in
                        print("changed")
            }
            self.observers.insert(ob as! NSObject)

            
        default:break
        }
        
    }
    
    @objc func nowPlayingItemChanged (_ n:Notification) {
        print("changed")
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch which {
        case 1:
            
            NotificationCenter.default.removeObserver(self)
            
        case 2:
            
            for ob in self.observers {
                NotificationCenter.default.removeObserver(ob)
            }
            self.observers.removeAll()
            
        default:break
        }
        
        let mp = MPMusicPlayerController.systemMusicPlayer
        mp.endGeneratingPlaybackNotifications()
    }
    



}

