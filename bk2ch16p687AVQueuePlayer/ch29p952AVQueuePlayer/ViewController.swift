

import UIKit
import MediaPlayer
import AVFoundation
import AVKit

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



protocol PlayerPauser {
    var isPlaying : Bool {get}
    func doPlay()
    func pause()
}

extension AVAudioPlayer : PlayerPauser {
    func doPlay() {
        self.play()
    }
}

extension AVPlayer : PlayerPauser {
    var isPlaying : Bool {
        return self.rate > 0.1
    }
    func doPlay() {
        self.play()
    }
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
    
    var player = Player()
    var avplayer : AVPlayer!
    var qp : AVQueuePlayer!
    var items = [AVPlayerItem]()
    var timeObserver : Any!
    @IBOutlet var prog : UIProgressView!
    @IBOutlet var label : UILabel!
    
    var curnum = 0
    var total = 0
    
    var curplayer : PlayerPauser!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func oneSong () -> (URL?, String?) {
        let query = MPMediaQuery.songs()
        // always need to filter out songs that aren't present
        let isPresent = MPMediaPropertyPredicate(value:false,
            forProperty:MPMediaItemPropertyIsCloudItem,
            comparisonType:.equalTo)
        query.addFilterPredicate(isPresent)
        let item = query.items?[0]
        return (item?.assetURL, item?.title)
    }
    
    func reset() {
        self.curplayer?.pause()
        self.curplayer = nil
        if self.children.count > 0 {
            let vc = self.children[0]
            vc.willMove(toParent: nil)
            vc.removeFromParent()
        }
        let scc = MPRemoteCommandCenter.shared()
        scc.togglePlayPauseCommand.removeTarget(nil)
        scc.playCommand.removeTarget(nil)
        scc.pauseCommand.removeTarget(nil)
        scc.nextTrackCommand.removeTarget(nil)
        // let scc = MPRemoteCommandCenter.shared()
        scc.togglePlayPauseCommand.addTarget(self, action: #selector(doPlayPause))
        scc.playCommand.addTarget(self, action:#selector(doPlay))
        scc.pauseCommand.addTarget(self, action:#selector(doPause))
        scc.nextTrackCommand.addTarget(self, action:#selector(doNextTrack))
        scc.changePlaybackPositionCommand.addTarget(self, action:#selector(doNextTrack))
        delay(1) { // we somehow get disabled after removing our player v.c.
            scc.togglePlayPauseCommand.isEnabled = true
            scc.playCommand.isEnabled = true
            scc.pauseCommand.isEnabled = true
            scc.nextTrackCommand.isEnabled = true
        }
    }
    
    @IBAction func doPlayOneSongAVAudioPlayer (_ sender: Any!) {
        self.reset()
        checkForMusicLibraryAccess {
            let (url, title) = self.oneSong()
            if let url = url {
                self.player.playFile(at:url)
                self.curplayer = self.player.player
                MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                    MPMediaItemPropertyTitle : title!,
//                    MPMediaItemPropertyPlaybackDuration : self.player.player.duration,
//                    MPNowPlayingInfoPropertyElapsedPlaybackTime : 0,
//                    MPNowPlayingInfoPropertyPlaybackRate : 1
                ]
            }
        }
    }
    
    @IBAction func doPlayOneSongAVPlayer (_ sender: Any!) {
        self.reset()
        checkForMusicLibraryAccess {
            self.curplayer?.pause()
            let (url, title) = self.oneSong()
            if let url = url {
                self.avplayer = AVPlayer(url:url)
                self.avplayer.play()
                self.curplayer = self.avplayer
            }
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle : title!,
//                MPMediaItemPropertyPlaybackDuration : self.avplayer.currentItem!.duration,
//                MPNowPlayingInfoPropertyElapsedPlaybackTime : 0,
//                MPNowPlayingInfoPropertyPlaybackRate : 1
            ]
        }
    }
    
    @IBAction func doPlayOneSongAVKit(_ sender: Any) {
        self.reset()
        checkForMusicLibraryAccess {
            self.curplayer?.pause()
            let (url,title) = self.oneSong()
            if let url = url {
                let p = AVPlayer(url:url)
                let vc = AVPlayerViewController()
                // don't let it steal our remote events
                vc.updatesNowPlayingInfoCenter = false
                vc.player = p
                self.addChild(vc)
                vc.didMove(toParent: self)
                p.play()
                self.curplayer = p
                
                MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                    MPMediaItemPropertyTitle : title!,
                    //                MPMediaItemPropertyPlaybackDuration : self.avplayer.currentItem!.duration,
                    //                MPNowPlayingInfoPropertyElapsedPlaybackTime : 0,
                    //                MPNowPlayingInfoPropertyPlaybackRate : 1
                ]

            }
        }
    }
    
    @IBAction func doPlayShortSongs (_ sender: Any!) {
        self.reset()
        checkForMusicLibraryAccess(andThen: self.reallyPlayShortSongs)
    }
    
    var obs = Set<NSKeyValueObservation>()
    
    func reallyPlayShortSongs() {
        let query = MPMediaQuery.songs()
        // always need to filter out songs that aren't present
        let isPresent = MPMediaPropertyPredicate(value:false,
            forProperty:MPMediaItemPropertyIsCloudItem,
            comparisonType:.equalTo)
        query.addFilterPredicate(isPresent)
        guard let items = query.items else {return}
        
        let shorties = items.filter {
            let dur = $0.playbackDuration
            return dur < 30
        }
        
        guard shorties.count > 0 else {
            print("no songs that short!")
            return
        }
        
        self.items = shorties.map {
            let url = $0.assetURL!
            let asset = AVAsset(url:url)
            return AVPlayerItem(
                asset: asset, automaticallyLoadedAssetKeys: [#keyPath(AVAsset.duration)])
            // duration needed later; this way, queue player will load it for us up front
        }
        
        self.curnum = 0
        self.total = self.items.count
        
        if self.timeObserver != nil && self.qp != nil {
            self.qp.removeTimeObserver(self.timeObserver)
        }
        
        let seed = min(3,self.items.count)
        self.qp = AVQueuePlayer(items:Array(self.items.prefix(upTo:seed)))
        self.items = Array(self.items.suffix(from:seed))
        
        // use .initial option so that we get an observation for the first item
        let ob = qp.observe(\.currentItem, options: .initial) { _,_ in
            self.changed()
        }
        self.obs.insert(ob)
        self.qp.play()
        self.curplayer = self.qp
        
        // UIApplication.shared.beginReceivingRemoteControlEvents()
        
        self.timeObserver = self.qp.addPeriodicTimeObserver(forInterval: CMTime(seconds:0.5, preferredTimescale:600), queue: nil) { [unowned self] t in
            self.timerFired(time:t)
        }
        
    }
    
    func changed() {
        guard let item = self.qp.currentItem else {return}
        self.curnum += 1
        var arr = item.asset.commonMetadata
        arr = AVMetadataItem.metadataItems(from:arr,
            withKey:AVMetadataKey.commonKeyTitle,
            keySpace:.common)
        let met = arr[0]
        let value = #keyPath(AVMetadataItem.value)
        met.loadValuesAsynchronously(forKeys:[value]) {
            // should always check for successful load of value
            if met.statusOfValue(forKey:value, error: nil) == .loaded {
                // can't be sure what thread we're on ...
                // ...or whether we'll be called back synchronously or asynchronously
                // so I like to step out to the main thread just in case
                guard let title = met.value as? String else {return}
                DispatchQueue.main.async {
                    self.label.text = "\(self.curnum) of \(self.total): \(title)"
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                        MPMediaItemPropertyTitle: title
                    ]
                }
            }
        }
        guard self.items.count > 0 else {return}
        let newItem = self.items.removeFirst()
        self.qp.insert(newItem, after:nil) // means "at end"
    }
    
    func timerFired(time:CMTime) {
        if let item = self.qp.currentItem {
            let asset = item.asset
            let dur = #keyPath(AVAsset.duration)
            if asset.statusOfValue(forKey:dur, error: nil) == .loaded {
                let dur = asset.duration
                self.prog.setProgress(Float(time.seconds/dur.seconds), animated: false)
                self.prog.isHidden = false
                if self.prog.progress > 0.999 {
                    if self.qp.items().count <= 1 {
                        self.label.text = ""
                        self.prog.isHidden = true
                        self.qp.removeTimeObserver(self.timeObserver)
                        self.timeObserver = nil
                        print("removing observer")
                    }
                }
            }
        }
    }
    
    
    
    // ======== respond to remote controls
    // but the AVPlayerViewController of itself has full r.c. support!
    // that is a huge advantage
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func doPlayPause(_ event:MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        print("playpause")
        if let p = self.curplayer {
            if p.isPlaying { p.pause() } else { p.doPlay() }
            return .success
        }
        return .noSuchContent
    }
    @objc func doPlay(_ event:MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        print("play")
        if let p = self.curplayer {
            p.doPlay()
            return .success
        }
        return .noSuchContent
    }
    @objc func doPause(_ event:MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        print("pause")
        if let p = self.curplayer {
            p.pause()
            return .success
        }
        return .noSuchContent
    }
    @objc func doNextTrack(_ event:MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        print("next")
        if let p = self.curplayer as? AVQueuePlayer {
            p.advanceToNextItem()
            return .success
        }
        return .noSuchContent
    }



}
