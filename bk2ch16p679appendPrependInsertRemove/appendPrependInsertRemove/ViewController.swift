

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
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        break
    }
}

class ViewController: UIViewController {
    let player = MPMusicPlayerController.applicationQueuePlayer
    // let player = MPMusicPlayerController.systemMusicPlayer
    override func viewDidLoad() {
        super.viewDidLoad()
        // load up short songs as a base queue
        checkForMusicLibraryAccess {
            let query = MPMediaQuery.songs()
            // always need to filter out songs that aren't present
            let isPresent = MPMediaPropertyPredicate(value:false,
                               forProperty:MPMediaItemPropertyIsCloudItem,
                                                     comparisonType:.equalTo)
            query.addFilterPredicate(isPresent)
            guard let items = query.items else {return} //
            
            let shorties = items.filter { //
                let dur = $0.playbackDuration
                return dur < 30
            }
            
            guard shorties.count > 0 else {
                print("no songs that short!")
                return
            }
            print("got \(shorties.count) short songs")
            let queue = MPMediaItemCollection(items:shorties)
            let player = self.player
            player.stop()
            player.setQueue(with:queue)
            player.prepareToPlay() // causes the queue to take effect
            //player.play()
            //player.stop()
        }
    }
    
    func createDesc() -> MPMusicPlayerMediaItemQueueDescriptor {
        let query = MPMediaQuery.albums()
        let hasSonata = MPMediaPropertyPredicate(value:"Sonata",
                                                 forProperty:MPMediaItemPropertyTitle,
                                                 comparisonType:.contains)
        query.addFilterPredicate(hasSonata)
        let isPresent = MPMediaPropertyPredicate(value:false,
                                                 forProperty:MPMediaItemPropertyIsCloudItem, // string name of property incorrect in header
            comparisonType:.equalTo)
        query.addFilterPredicate(isPresent)
        let result = query.items!
        let song = result[0]
        let predicate = MPMediaPropertyPredicate(
            value: song.persistentID,
            forProperty: MPMediaItemPropertyPersistentID)
        let query2 = MPMediaQuery(filterPredicates: [predicate])
        let qd = MPMusicPlayerMediaItemQueueDescriptor(query:query2)
        return qd
    }
    
    @IBAction func doAppend(_ sender: Any) {
        checkForMusicLibraryAccess {
            let player = self.player
            player.append(self.createDesc())
            delay(1) { // can't do this too soon or we "time out"
                player.perform(queueTransaction: {q in
                    print(q.items.map{$0.title!})
                }) {q, err in
                    if let err = err { print(err) }
                }
            }
            // correct way, instead of delay, is probably to use MPMusicPlayerControllerQueueDidChange notification
        }
    }
    
    // allow the player to play one or two songs first;
    // that way, you see that prepend means insert before currently playing item
    @IBAction func doPrepend(_ sender: Any) {
        checkForMusicLibraryAccess {
            let player = self.player
            player.prepend(self.createDesc())
            delay(1) { // can't do this too soon or we "time out"
                player.perform(queueTransaction: {q in
                    print(q.items.map{$0.title!})
                }) {q, err in
                    if let err = err { print(err) }
                }
            }
        }
    }

    @IBAction func doInsert(_ sender: Any) {
        checkForMusicLibraryAccess {
            let qd = self.createDesc()
            let player = self.player
            player.perform(queueTransaction: {q in
                print("before:", q.items.map{$0.title!})
                q.insert(qd, after:nil)
            }) {q, err in
                if let err = err { print(err) }
                print("after:", q.items.map{$0.title!})
            }
        }
    }
    
    @IBAction func doRemove(_ sender: Any) {
        checkForMusicLibraryAccess {
            let player = self.player
            player.perform(queueTransaction: {q in
                print("before:", q.items.map{$0.title!})
                q.remove(q.items[3])
            }) {q, err in
                if let err = err { print(err) }
                print("after:", q.items.map{$0.title!})
            }
        }
    }

    @IBAction func doStop(_ sender: Any) {
        let state = player.playbackState
        print("state:", state.rawValue)
        player.perform(queueTransaction: {q in
            print(q.items.map{$0.title!})
        }) {q, err in
            if let err = err { print(err) }
        }

        if state == .playing {
            player.pause()
        } else {
            player.play()
        }
    }

}

