

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
        self.baseQueue()
    }
    
    // load up short songs as a base queue
    @IBAction func baseQueue() {
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
            delay(0.2) {
                // player.prepareToPlay() // causes the queue to take effect
                player.prepareToPlay() { err in
                    
                }
            }
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
        let coll = MPMediaItemCollection(items: [song])
        return MPMusicPlayerMediaItemQueueDescriptor(itemCollection: coll)
    }
    
    @IBAction func doAppend(_ sender: Any) {
        checkForMusicLibraryAccess {
            let player = self.player
            player.append(self.createDesc())
            delay(0.2) { // can't do this too soon or we "time out"
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
    // that way, you see that prepend means insert after currently playing item
    @IBAction func doPrepend(_ sender: Any) {
        checkForMusicLibraryAccess {
            let player = self.player
            player.prepend(self.createDesc())
            delay(0.2) { // can't do this too soon or we "time out"
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
                q.insert(qd, after:q.items.last!) // bug: if `after:` is not nil, nothing happens
            }) {q, err in
                // well, dammit, there's another bug!
                // the queue does not reflect the change we just made!
                if let err = err { print(err) }
                print("after:", q.items.map{$0.title!})
                delay(0.2) {
                    player.perform(queueTransaction: { qq in
                        print("after after:", qq.items.map{$0.title!})
                    }) { _,_ in }
                }
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
                // same bug; the change is not reflected correctly
                if let err = err { print(err) }
                print("after:", q.items.map{$0.title!})
                delay(0.2) {
                    player.perform(queueTransaction: { qq in
                        print("after after:", qq.items.map{$0.title!})
                    }) { _,_ in }
                }
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

