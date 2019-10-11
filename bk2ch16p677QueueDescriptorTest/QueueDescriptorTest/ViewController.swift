

import UIKit
import MediaPlayer

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


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
        let url = URL(string:UIApplication.openSettingsURLString)!
        UIApplication.shared.open(url)
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        break
    @unknown default: fatalError()
    }
}


class ViewController: UIViewController {
    
    let player = MPMusicPlayerController.applicationQueuePlayer
    // let player = MPMusicPlayerController.systemMusicPlayer

    
    
    @IBAction func doStop(_ sender: Any) {
        if self.player.playbackState == .playing {
            self.player.stop()
        }
    }
    
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        checkForMusicLibraryAccess {
            
            let songs = MPMediaQuery.songs()
            let result = songs.items
            guard let items = result, items.count > 0 else {return}
            let song = items[0]
                        
            if self.player.playbackState == .playing {
                print("stopping")
                self.player.stop()
            }
            
            /*
             setQueue(with query: MPMediaQuery)
             
             setQueue(with itemCollection: MPMediaItemCollection)
             
             setQueue(with descriptor: MPMusicPlayerQueueDescriptor)
             
             also setQueue(with storeIDs: [String]) but that's outside my wheelhouse
             */
            
            // thus there are four possibilities...
            // true,true succeeds
            // true,false succeeds
            // false,true succeeds
            // false,false succeeds
            
            // ok, I learned something very important!
            // they all work _if you use an instance property_
            
            var useDescriptor : Bool { return true }
            var useCollection : Bool { return true }
            
            let coll = MPMediaItemCollection(items: [song])
            let predicate = MPMediaPropertyPredicate(
                value: song.persistentID,
                forProperty: MPMediaItemPropertyPersistentID)
            let query = MPMediaQuery(filterPredicates: [predicate])
            
            switch (useDescriptor, useCollection) {
            case (false,false):
                print("setting queue with item collection")
                self.player.setQueue(with: coll)
            case (false,true):
                print("setting queue with query")
                self.player.setQueue(with: query)
            case (true,true):
                print("setting queue with descriptor, item collection")
                let desc = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: coll)
                self.player.setQueue(with: desc)
            case (true,false):
                print("setting queue with descriptor, query")
                let desc = MPMusicPlayerMediaItemQueueDescriptor(query: query)
                self.player.setQueue(with: desc)
            }
            
            print("trying to play")
            self.player.play()
        }
    }



}

