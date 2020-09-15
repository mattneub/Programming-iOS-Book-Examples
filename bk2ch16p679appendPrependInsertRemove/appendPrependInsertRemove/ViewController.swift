

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
    @unknown default: fatalError()
    }
}

class ViewController: UIViewController {
    let player = MPMusicPlayerController.applicationQueuePlayer
    // let player = MPMusicPlayerController.systemMusicPlayer
    var ob : NSObjectProtocol?
    var lock = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let ob = NotificationCenter.default.addObserver(
            forName: .MPMusicPlayerControllerQueueDidChange,
            object: self.player, queue: OperationQueue.main) { n in
                // okay, after hours of testing I determined that
                // implementing this method to call `player.perform(queueTransaction:)`,
                // even empty, will cause a crash or other failure with the player
                // my attempts to work around this have failed
                // okay, I think the reason is that calling player.perform itself changes the queue!
                // but I seem to be unable to set up a lock to prevent overlap
                // this crude pseudo-lock seems to work!
                print("change")
                if self.lock { return }
                self.lock = true
                self.player.perform(queueTransaction: {q in
                    NSLog("perform")
                    print(q.items.map{$0.title!})
                }, completionHandler: {_,_ in
                    NSLog("completion")
                    self.lock = false
                })
        }
        self.ob = ob
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
            if self.player.playbackState == .playing {
                self.player.stop()
            }
            print("setting queue")
            self.player.setQueue(with:queue)
            delay(0.2) { // definitely need this here
                print("playing")
                self.player.play()
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
            print("appending")
            self.player.append(self.createDesc())
            // this fails because it is too soon, the change has not happened yet
//            self.player.perform(queueTransaction: {q in
//            }, completionHandler: {q,_ in
//                print(q.items.map{$0.title!})
//            })

        }
    }
    
    // allow the player to play one or two songs first;
    // that way, you see that prepend means insert after currently playing item
    @IBAction func doPrepend(_ sender: Any) {
        checkForMusicLibraryAccess {
            print("prepending")
            self.player.prepend(self.createDesc()) // works correctly, though I sometimes hear a glitch at that moment
            // this fails because it is too soon, the change has not happened yet
//            self.player.perform(queueTransaction: {q in
//            }, completionHandler: {q,_ in
//                print(q.items.map{$0.title!})
//            })
        }
    }

    @IBAction func doInsert(_ sender: Any) {
        checkForMusicLibraryAccess {
            let qd = self.createDesc()

            self.player.perform(queueTransaction: {q in
                print("inserting")
                q.insert(qd, after:q.items[3]) // okay, they fixed that one anyway! this works
                // plus there is no audible glitch, nice
            }) {q, err in
                if let err = err { print("error", err) }
                // and they fixed the delay issue for this one!
                print("and the queue is now")
                print(q.items.map{$0.title!})
            }
        }
    }
    
    @IBAction func doRemove(_ sender: Any) {
        checkForMusicLibraryAccess {
            self.player.perform(queueTransaction: {q in
            }, completionHandler: {q,_ in
                print("before removing")
                print(q.items.map{$0.title!})
                self.player.perform(queueTransaction: {q in
                    print("removing")
                    q.remove(q.items[3])
                }) {q, err in
                    if let err = err { print("error", err) }
                    print("and the queue is now")
                    print(q.items.map{$0.title!})
                }
            })
        }
    }

    @IBAction func doStop(_ sender: Any) {
        let state = player.playbackState
//        print("state:", state.rawValue)
//        player.perform(queueTransaction: {q in
//            print(q.items.map{$0.title!})
//        }) {q, err in
//            // if let err = err { print(err) }
//            // there is _always_ an error because we didn't transact
//        }

        if state == .playing {
            player.pause()
        } else {
            player.play()
        }
    }

}

