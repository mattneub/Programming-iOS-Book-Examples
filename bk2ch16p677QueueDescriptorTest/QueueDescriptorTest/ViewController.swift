

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
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        break
    }
}


class ViewController: UIViewController {
    
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        checkForMusicLibraryAccess {
            let query = MPMediaQuery.songs()
            let result = query.items
            guard let items = result, items.count > 0 else {return}
            let song = items[0]
            
            let player = MPMusicPlayerController.applicationQueuePlayer
            
            // proving that MPMusicPlayerMediaItemQueueDescriptor(itemCollection:) is broken
            
            let useCollection = true
            
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

