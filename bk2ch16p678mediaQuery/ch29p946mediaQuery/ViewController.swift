

import UIKit
import MediaPlayer

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}

// general solution to the access problem

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
        break
        // do nothing, or beg the user to authorize us in Settings
        let url = URL(string:UIApplication.openSettingsURLString)!
        UIApplication.shared.open(url)
    @unknown default: fatalError()
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var label : UILabel!
    var timer : Timer?
    @IBOutlet var prog : UIProgressView!
    @IBOutlet var vv : MPVolumeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sz = CGSize(20,20)
        let r = UIGraphicsImageRenderer(size:sz)
        let im1 = r.image {
            _ in
            UIColor.black.setFill()
            UIBezierPath(ovalIn:
                CGRect(0,0,sz.height,sz.height)).fill()
        }
        let im2 = r.image {
            _ in
            UIColor.red.setFill()
            UIBezierPath(ovalIn:
                CGRect(0,0,sz.height,sz.height)).fill()
        }
        let im3 = r.image {
            _ in
            UIColor.orange.setFill()
            UIBezierPath(ovalIn:
                CGRect(0,0,sz.height,sz.height)).fill()
        }

        self.vv.setMinimumVolumeSliderImage(
            im1.resizableImage(withCapInsets:UIEdgeInsets(top: 9,left: 9,bottom: 9,right: 9),
                resizingMode:.stretch),
            for:.normal)
        self.vv.setMaximumVolumeSliderImage(
            im2.resizableImage(withCapInsets:UIEdgeInsets(top: 9,left: 9,bottom: 9,right: 9),
                resizingMode:.stretch),
            for:.normal)
        // only for EU devices; to test, use the EU switch under Developer settings on device
        self.vv.volumeWarningSliderImage =
            im3.resizableImage(withCapInsets:UIEdgeInsets(top: 9,left: 9,bottom: 9,right: 9),
                resizingMode:.stretch)
        
        let sz2 = CGSize(40,40)
        let r2 = UIGraphicsImageRenderer(size:sz2)
        let thumb = r2.image {_ in
            UIImage(named:"SmileyRound.png")!.draw(in:CGRect(origin:.zero,size:sz2))
        }
        self.vv.setVolumeThumbImage(thumb, for:.normal)
        
        
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(wirelessChanged),
            name:.AVRouteDetectorMultipleRoutesDetectedDidChange,
            object:nil)
    }
    
    @objc func wirelessChanged(_ n:Notification) {
        print("route change \(n.userInfo as Any)")
    }
    
    @objc func dummy() {
        
    }
    
    @IBAction func doAllAlbumTitles (_ sender: Any) {
//        checkForMusicLibraryAccess()
//        checkForMusicLibraryAccess(andThen:self.dummy)
        checkForMusicLibraryAccess {
            skip: do {
                break skip
                let query = MPMediaQuery() // just making sure this is legal
                let result = query.items
                _ = result
                // just testing the syntax; this notification name is not yet namespaced
                NotificationCenter.default.addObserver(self, selector: #selector(self.dummy), name: .MPMediaLibraryDidChange, object: nil)
            }
            let query = MPMediaQuery.albums()
            guard let result = query.collections else {return} //
            // prove we've performed the query, by logging the album titles
            for album in result {
                print(album.representativeItem!.albumTitle!) //
                // just showing the syntax
                _ = album.representativeItem!.value(forProperty: MPMediaItemPropertyTitle)
            }
            return // testing
            // cloud item values are 0 and 1, meaning false and true
            for album in result {
                for song in album.items { //
                    print("\(song.isCloudItem) \(song.assetURL as Any) \(song.title as Any)")
                }
            }
        }
    }
    
    @IBAction func doBeethovenAlbumTitles (_ sender: Any) {
        checkForMusicLibraryAccess {
            let query = MPMediaQuery.albums()
            let hasBeethoven = MPMediaPropertyPredicate(value:"Beethoven",
                forProperty:MPMediaItemPropertyAlbumTitle,
                comparisonType:.contains)
            query.addFilterPredicate(hasBeethoven)
            guard let result = query.collections else {return} //
            for album in result {
                print(album.representativeItem!.albumTitle!) //
            }
        }
    }
    
    @IBAction func doSonataAlbumsOnDevice (_ sender: Any) {
        checkForMusicLibraryAccess {
            let query = MPMediaQuery.albums()
            let hasSonata = MPMediaPropertyPredicate(value:"Sonata",
                forProperty:MPMediaItemPropertyTitle,
                comparisonType:.contains)
            query.addFilterPredicate(hasSonata)
            let isPresent = MPMediaPropertyPredicate(value:false,
                forProperty:MPMediaItemPropertyIsCloudItem, // string name of property incorrect in header
                comparisonType:.equalTo)
            query.addFilterPredicate(isPresent)
            
            guard let result = query.collections else {return} //
            for album in result {
                print(album.representativeItem!.albumTitle!)
            }
            // and here are the songs in the first of those albums
            guard result.count > 0 else {print("No sonatas"); return}
            let album = result[0]
            for song in album.items { //
                print(song.title!)
            }
        }
    }
    
    let player = MPMusicPlayerController.applicationQueuePlayer
    
    @IBAction func doStop(_ sender: Any) {
        print("invalidating timer, stopping player")
        self.timer?.invalidate()
        self.timer = nil
        if self.player.playbackState == .playing {
            self.player.stop()
        }
        delay(1) {
            // let's find out what this does to the queue
            self.player.perform(queueTransaction: { q in
                print(q.items.count, q.items.map {$0.title ?? "no title"})
                // okay so it looks like it no longer empties the queue
                // so there is now no difference between pausing and stopping?
            }, completionHandler: {_,_ in})
        }
    }
    
    @IBAction func doPlayShortSongs (_ sender: Any) {
        print("do play short songs")
        checkForMusicLibraryAccess {
            // configure notification on main queue
            self.player.beginGeneratingPlaybackNotifications()
            NotificationCenter.default.removeObserver(self) // let's not add ourselves twice by mistake eh
            NotificationCenter.default.addObserver(self, selector: #selector(self.changed), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: self.player)
            
            // get off main queue, allow button to unhighlight
            DispatchQueue.global(qos:.userInitiated).async {
                
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
                print("got \(shorties.count) short songs:")
                print(shorties.map {$0.title ?? "no title"})
                let queue = MPMediaItemCollection(items:shorties)
                
                // get back on main thread to talk to player
                
                DispatchQueue.main.async {
                    
                    print("stopping")
                    if self.player.playbackState == .playing {
                        self.player.stop()
                    }
                    print("setting shuffle mode")
                    self.player.shuffleMode = .songs
                    
                    self.player.setQueue(with:queue)
                    print("playing")
                    self.player.play()
                    print("starting time")
                    self.timer = Timer.scheduledTimer(timeInterval:1, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
                    self.timer?.tolerance = 0.1
                }
            }
            
        }
    }
    
    @objc func changed(_ n:Notification) {
        print("now playing item changed!")
        defer {
            self.timer?.fire() // looks better if we fire timer now
        }
        self.label.text = ""
        let player = self.player
        guard let obj = n.object, obj as AnyObject === player else { return } // just playing safe
        guard let title = player.nowPlayingItem?.title else {return}
        if player.playbackState != .playing {print("stopped"); return}
        let ix = player.indexOfNowPlayingItem
        guard ix != NSNotFound else {return}
        // new, we can get the queue!
        player.perform(queueTransaction: { q in
            print(q.items.count, q.items.map {$0.title ?? "no title"})
            self.label.text = "\(ix+1) of \(q.items.count): \(title)"
        }, completionHandler: {_,_ in})
    }
    
    @objc func timerFired(_: Any) {
        print("timer fired")
        let player = self.player
        guard let item = player.nowPlayingItem, player.playbackState != .stopped else {
            self.prog.isHidden = true
            return
        } //
        self.prog.isHidden = false
        let current = player.currentPlaybackTime
        let total = item.playbackDuration
        self.prog.progress = Float(current / total)
    }
        
}

class MyVolumeView : MPVolumeView {

    
    override func volumeSliderRect(forBounds bounds: CGRect) -> CGRect {
        // print("slider rect", bounds)
        return super.volumeSliderRect(forBounds: bounds)
    }
    
    override func volumeThumbRect(forBounds bounds: CGRect, volumeSliderRect rect: CGRect, value: Float) -> CGRect {
        // print("thumb rect", value)
        return super.volumeThumbRect(forBounds: bounds, volumeSliderRect: rect, value: value)
    }

}

