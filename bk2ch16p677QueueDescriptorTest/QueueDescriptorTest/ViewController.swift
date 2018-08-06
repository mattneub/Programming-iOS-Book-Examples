

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
            
            let query = MPMediaQuery.songs()
            let result = query.items
            guard let items = result, items.count > 0 else {return}
            let song = items[0]
            
            let player = MPMusicPlayerController.applicationQueuePlayer
            
            var useCollection : Bool { return false }
            
            if useCollection {
                let coll = MPMediaItemCollection(items: [song])
                let q = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: coll)
                player.stop(); print("stopping")
                print("setting queue with item collection")
                player.setQueue(with: q)
            } else {
                let predicate = MPMediaPropertyPredicate(
                    value: song.persistentID,
                    forProperty: MPMediaItemPropertyPersistentID)
                let query = MPMediaQuery(filterPredicates: [predicate])
                let q = MPMusicPlayerMediaItemQueueDescriptor(query: query)
                player.stop(); print("stopping")
                print("setting queue with query")
                player.setQueue(with: q)
            }
            
            // delay between setting queue and starting to play seems to be crucial
            print("inserting delay")
            delay(0.2) {
                print("calling prepareToPlay")
                player.prepareToPlay { err in
                    if let err = err {
                        print("printing error")
                        print(err)
                        return
                    }
                    print("trying to play")
                    player.play()
                }
            }
        }
    }



}

