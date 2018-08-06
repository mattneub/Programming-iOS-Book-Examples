

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
    }
}


class ViewController: UIViewController {
    
    
    @IBAction func doStop(_ sender: Any) {
        let player = MPMusicPlayerController.applicationQueuePlayer
        player.stop()
    }
    
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        checkForMusicLibraryAccess {
            
            let songs = MPMediaQuery.songs()
            let result = songs.items
            guard let items = result, items.count > 0 else {return}
            let song = items[0]
            
            let player = MPMusicPlayerController.applicationQueuePlayer
            // let player = MPMusicPlayerController.systemMusicPlayer
            
            print("stopping")
            player.stop()
            
            /*
             setQueue(with query: MPMediaQuery)
             
             setQueue(with itemCollection: MPMediaItemCollection)
             
             setQueue(with descriptor: MPMusicPlayerQueueDescriptor)
             
             also setQueue(with storeIDs: [String]) but that's outside my wheelhouse
             */
            
            // thus there are four possibilities...
            // and at the moment they all work
            
            var useCollection : Bool { return true }
            var useDescriptor : Bool { return false }
            
            let coll = MPMediaItemCollection(items: [song])
            let predicate = MPMediaPropertyPredicate(
                value: song.persistentID,
                forProperty: MPMediaItemPropertyPersistentID)
            let query = MPMediaQuery(filterPredicates: [predicate])
            
            switch (useDescriptor, useCollection) {
            case (false,false):
                print("setting queue with item collection")
                player.setQueue(with: coll)
            case (false,true):
                print("setting queue with query")
                player.setQueue(with: query)
            case (true,true): // descriptor, item collection
                print("setting queue with descriptor, item collection")
                let desc = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: coll)
                player.setQueue(with: desc)
            case (true,false): // descriptor, query
                print("setting queue with descriptor, query")
                let desc = MPMusicPlayerMediaItemQueueDescriptor(query: query)
                player.setQueue(with: desc)
            }
            
            print("inserting delay")
            delay(0.2) {
                player.prepareToPlay { err in
                    if let err = err {
                        print("printing error")
                        print(err)
                        return
                    }
                    print("trying to play")
                    // weird: no need to actually say play!
                    // player.play()
                }
            }
        }
    }



}

