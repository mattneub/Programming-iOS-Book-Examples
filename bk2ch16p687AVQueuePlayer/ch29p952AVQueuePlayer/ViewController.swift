

import UIKit
import MediaPlayer
import AVFoundation
import CoreMedia
import AVKit

protocol PlayerPauser {
    var playing : Bool {get}
    func doPlay()
    func pause()
}

extension AVAudioPlayer : PlayerPauser {
    func doPlay() {
        self.play()
    }
}

extension AVPlayer : PlayerPauser {
    var playing : Bool {
        return self.rate > 0.1
    }
    func doPlay() {
        self.play()
    }
}

class ViewController: UIViewController {
    
    var player = Player()
    var avplayer : AVPlayer!
    var qp : AVQueuePlayer!
    var items = [AVPlayerItem]()
    var timer : NSTimer!
    @IBOutlet var prog : UIProgressView!
    @IBOutlet var label : UILabel!
    
    var curnum = 0
    var total = 0
    
    var curplayer : PlayerPauser!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func oneSong () -> NSURL? {
        let query = MPMediaQuery.songsQuery()
        // always need to filter out songs that aren't present
        let isPresent = MPMediaPropertyPredicate(value:false,
            forProperty:MPMediaItemPropertyIsCloudItem,
            comparisonType:.EqualTo)
        query.addFilterPredicate(isPresent)
        return query.items?[0].assetURL
    }
    
    @IBAction func doPlayOneSongAVAudioPlayer (sender:AnyObject!) {
        self.curplayer?.pause()
        if let url = self.oneSong() {
            self.player.playFileAtURL(url)
            self.curplayer = self.player.player
        }
    }
    
    @IBAction func doPlayOneSongAVPlayer (sender:AnyObject!) {
        self.curplayer?.pause()
        if let url = self.oneSong() {
            self.avplayer = AVPlayer(URL:url)
            self.avplayer.play()
            self.curplayer = self.avplayer
        }
    }
    
    @IBAction func doPlayOneSongAVKit(sender: AnyObject) {
        self.curplayer?.pause()
        guard let url = self.oneSong() else {return}
        let p = AVPlayer(URL:url)
        let vc = AVPlayerViewController()
        vc.player = p
        vc.view.frame = CGRectMake(20,-5,250,80) // no smaller height or we get constraint issues
        vc.view.backgroundColor = UIColor.clearColor()
        // cover the black QuickTime background, heh heh
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.whiteColor()
        vc.contentOverlayView!.addSubview(v)
        let c : [NSLayoutConstraint] = [
            v.leadingAnchor.constraintEqualToAnchor(v.superview!.leadingAnchor),
            v.trailingAnchor.constraintEqualToAnchor(v.superview!.trailingAnchor),
            v.topAnchor.constraintEqualToAnchor(v.superview!.topAnchor),
            v.bottomAnchor.constraintEqualToAnchor(v.superview!.bottomAnchor),
        ]
        NSLayoutConstraint.activateConstraints(c)
        let v2 = UIView()
        v2.translatesAutoresizingMaskIntoConstraints = false
        v2.backgroundColor = UIColor.blackColor()
        vc.contentOverlayView!.addSubview(v2)
        let c2 : [NSLayoutConstraint] = [
            v2.leadingAnchor.constraintEqualToAnchor(v2.superview!.leadingAnchor),
            v2.trailingAnchor.constraintEqualToAnchor(v2.superview!.trailingAnchor),
            v2.heightAnchor.constraintEqualToConstant(44),
            v2.bottomAnchor.constraintEqualToAnchor(v2.superview!.bottomAnchor),
        ]
        NSLayoutConstraint.activateConstraints(c2)
        
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
        p.play()
        self.curplayer = p
    }
    
    @IBAction func doPlayShortSongs (sender:AnyObject!) {
        self.curplayer?.pause()
        let query = MPMediaQuery.songsQuery()
        // always need to filter out songs that aren't present
        let isPresent = MPMediaPropertyPredicate(value:false,
            forProperty:MPMediaItemPropertyIsCloudItem,
            comparisonType:.EqualTo)
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
            let asset = AVAsset(URL:url)
            return AVPlayerItem(
                asset: asset, automaticallyLoadedAssetKeys: ["duration"])
            // duration needed later; this way, queue player will load it for us up front
        }
        
        self.curnum = 0
        self.total = self.items.count
        
        let seed = min(3,self.items.count)
        self.qp = AVQueuePlayer(items:Array(self.items.prefixUpTo(seed)))
        self.items = Array(self.items.suffixFrom(seed))
        
        // use .Initial option so that we get an observation for the first item
        self.qp.addObserver(self, forKeyPath:"currentItem", options:.Initial, context:nil)
        self.qp.play()
        self.curplayer = self.qp
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
        self.timer.fire()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if keyPath == "currentItem" {
            self.changed()
        }
    }
    
    func changed() {
        defer {
            self.timer?.fire()
        }
        guard let item = self.qp.currentItem else {return}
        self.curnum++
        var arr = item.asset.commonMetadata
        arr = AVMetadataItem.metadataItemsFromArray(arr,
            withKey:AVMetadataCommonKeyTitle,
            keySpace:AVMetadataKeySpaceCommon)
        let met = arr[0]
        met.loadValuesAsynchronouslyForKeys(["value"]) {
            // should always check for successful load of value
            if met.statusOfValueForKey("value", error: nil) == .Loaded {
                // can't be sure what thread we're on ...
                // ...or whether we'll be called back synchronously or asynchronously
                // so I like to step out to the main thread just in case
                guard let title = met.value as? String else {return}
                dispatch_async(dispatch_get_main_queue()) {
                    self.label.text = "\(self.curnum) of \(self.total): \(title)"
                    MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
                        MPMediaItemPropertyTitle: title
                    ]
                }
            }
        }
        guard self.items.count > 0 else {return}
        let newItem = self.items.removeFirst()
        self.qp.insertItem(newItem, afterItem:nil) // means "at end"
    }
    
    func timerFired(sender:AnyObject) {
        if let item = self.qp.currentItem {
            let asset = item.asset
            if asset.statusOfValueForKey("duration", error: nil) == .Loaded {
                let cur = self.qp.currentTime()
                let dur = asset.duration
                self.prog.progress = Float(CMTimeGetSeconds(cur)/CMTimeGetSeconds(dur))
                self.prog.hidden = false
            }
        } else {
            self.label.text = ""
            self.prog.hidden = true
            self.timer.invalidate()
        }
    }
    
    
    
    // ======== respond to remote controls
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        let rc = event!.subtype
        print("received remote control \(rc.rawValue)")
        
        let p = self.curplayer
        switch rc {
        case .RemoteControlTogglePlayPause:
            if p.playing { p.pause() } else { p.doPlay() }
        case .RemoteControlPlay:
            p.doPlay()
        case .RemoteControlPause:
            p.pause()
        case .RemoteControlNextTrack:
            if let p = p as? AVQueuePlayer {
                p.advanceToNextItem()
            }
        default:break
        }
        
    }
    
    
    
}
