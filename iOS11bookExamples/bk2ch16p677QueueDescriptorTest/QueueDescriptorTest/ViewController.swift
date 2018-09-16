

import UIKit
import MediaPlayer

func checkForMusicLibraryAccess(andThen f:(()->())? = nil) {
    let status = MPMediaLibrary.authorizationStatus()
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        MPMediaLibrary.requestAuthorization() { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
        // just testing the syntax; this is how you get to the settings app
        let url = URL(string:UIApplicationOpenSettingsURLString)!
        UIApplication.shared.open(url)
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        break
    }
}


class ViewController: UIViewController {
    
    override func remoteControlReceived(with event: UIEvent?) {
        print("remote!")
    }
    
    override var canBecomeFirstResponder: Bool { return true }
    
    @IBAction func doStop(_ sender: Any) {
        let player = MPMusicPlayerController.applicationQueuePlayer
        player.stop()
    }
    
    @objc func doPause(_ event:MPRemoteCommandEvent) {
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        checkForMusicLibraryAccess {
            
            // proving that control center never sees us as remote target
            
            // this doesn't help
            self.becomeFirstResponder()
            UIApplication.shared.beginReceivingRemoteControlEvents()
            
            // this doesn't help
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try? AVAudioSession.sharedInstance().setActive(true)
            
            // this doesn't help
            let scc = MPRemoteCommandCenter.shared()
            scc.pauseCommand.addTarget(self, action:#selector(self.doPause))
            
            // this doesn't help
            MPMusicPlayerController.systemMusicPlayer.stop()

            // so under what circumstances are we ever the remote target?
            
            let query = MPMediaQuery.songs()
            let result = query.items
            guard let items = result, items.count > 0 else {return}
            let song = items[0]
            
            // this has no effect either
            let mpic = MPNowPlayingInfoCenter.default()
            mpic.nowPlayingInfo = [
                MPMediaItemPropertyArtist: song.artist!,
                MPMediaItemPropertyTitle: song.title!,
            ]

            
            let player = MPMusicPlayerController.applicationQueuePlayer
            
            // proving that MPMusicPlayerMediaItemQueueDescriptor(itemCollection:) is broken
            
            let useCollection = false
            
            if useCollection {
                let coll = MPMediaItemCollection(items: [song])
                let q = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: coll)
                player.setQueue(with: q)
            } else {
                let predicate = MPMediaPropertyPredicate(
                    value: song.persistentID,
                    forProperty: MPMediaItemPropertyPersistentID)
                let query = MPMediaQuery(filterPredicates: [predicate])
                let q = MPMusicPlayerMediaItemQueueDescriptor(query: query)
                player.setQueue(with: q)
            }
            
            player.prepareToPlay { err in
                if let err = err {
                    print(err) // not found (storefront???)
                    return
                }
                print("trying to play")
                player.play()
            }
        }
    }



}

