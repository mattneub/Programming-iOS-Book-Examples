

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

// really shouldn't be using this one any more

extension MPMoviePlayerController : PlayerPauser {
    var playing : Bool {
        return self.currentPlaybackRate > 0.1
    }
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
    var mpc : MPMoviePlayerController!
    var qp : AVQueuePlayer!
    var assets = [AVPlayerItem]()
    var timer : NSTimer!
    @IBOutlet var prog : UIProgressView!
    @IBOutlet var label : UILabel!
    
    var curnum = 0
    var total = 0
    
    var curplayer : PlayerPauser!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func oneSong () -> NSURL {
        let query = MPMediaQuery.songsQuery()
        // always need to filter out songs that aren't present
        let isPresent = MPMediaPropertyPredicate(value:false,
            forProperty:MPMediaItemPropertyIsCloudItem,
            comparisonType:.EqualTo)
        query.addFilterPredicate(isPresent)
        return query.items[0].assetURL
    }
    
    @IBAction func doPlayOneSongAVAudioPlayer (sender:AnyObject!) {
        self.curplayer?.pause()
        let url = self.oneSong()
        self.player.playFileAtURL(url)
        self.curplayer = self.player.player
    }
    
    @IBAction func doPlayOneSongMPMoviePlayerController (sender:AnyObject!) {
        self.curplayer?.pause()
        let url = self.oneSong()
        let mpc = MPMoviePlayerController(contentURL:url)
        self.mpc = mpc
        mpc.prepareToPlay()
        mpc.view.frame = CGRectMake(20,20,250,20)
        mpc.backgroundView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(mpc.view)
        self.curplayer = mpc
    }

    @IBAction func doPlayOneSongAVPlayer (sender:AnyObject!) {
        self.curplayer?.pause()
        let url = self.oneSong()
        self.avplayer = AVPlayer(URL:url)
        self.avplayer.play()
        self.curplayer = self.avplayer
    }
    
    @IBAction func doPlayOneSongAVKit(sender: AnyObject) {
        self.curplayer?.pause()
        let url = self.oneSong()
        let p = AVPlayer(URL:url)
        let vc = AVPlayerViewController()
        vc.player = p
        vc.view.frame = CGRectMake(20,10,250,60) // no smaller height or we get constraint issues
        // cover the black background, heh heh
        let v = UIView(frame:CGRectMake(0,0,250,60))
        v.backgroundColor = UIColor.blackColor()
        vc.contentOverlayView.addSubview(v)
        let v2 = UIView(frame:CGRectMake(0,0,250,20))
        v2.backgroundColor = UIColor.whiteColor()
        vc.contentOverlayView.addSubview(v2)

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
        
        let shorties = (query.items as! [MPMediaItem]).filter {
            let dur = $0.playbackDuration
            return dur < 30
        }
        
        if shorties.count == 0 {
            println("no songs that short!")
            return
        }
        
        self.assets = shorties.map {
            let url = $0.assetURL
            let asset = AVAsset.assetWithURL(url) as! AVAsset
            return AVPlayerItem(
                asset: asset, automaticallyLoadedAssetKeys: ["duration"])
            // duration needed later; this way, queue player will load it for us up front
        }
        
        self.curnum = 0
        self.total = self.assets.count
        
        let seed = min(3,self.assets.count)
        self.qp = AVQueuePlayer(items:Array(self.assets[0..<0+seed]))
        self.assets = Array(self.assets[seed..<self.assets.count])
        
        // use .Initial option so that we get an observation for the first item
        self.qp.addObserver(self, forKeyPath:"currentItem", options:.Initial, context:nil)
        self.qp.play()
        self.curplayer = self.qp
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()

        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
        self.timer.fire()
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        if keyPath == "currentItem" {
            self.changed()
        }
    }
    
    func changed() {
        let item = self.qp.currentItem
        if item == nil {
            self.timer?.fire()
            return
        }
        self.curnum++
        var arr = item.asset.commonMetadata
        arr = AVMetadataItem.metadataItemsFromArray(arr,
            withKey:AVMetadataCommonKeyTitle,
            keySpace:AVMetadataKeySpaceCommon)
        let met = arr[0] as! AVMetadataItem
        met.loadValuesAsynchronouslyForKeys(["value"]) {
            // should always check for successful load of value
            if met.statusOfValueForKey("value", error: nil) == .Loaded {
                // can't be sure what thread we're on ...
                // ...or whether we'll be called back synchronously or asynchronously
                // so I like to step out to the main thread just in case
                dispatch_async(dispatch_get_main_queue()) {
                    self.label.text = "\(self.curnum) of \(self.total): \(met.value)"
                    MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
                        MPMediaItemPropertyTitle: met.value
                        ]
                }
            }
        }
        if self.assets.count == 0 {
            return
        }
        let newItem = self.assets.removeAtIndex(0)
        self.qp.insertItem(newItem, afterItem:self.qp.items().last as! AVPlayerItem)
        
        self.timer?.fire()
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
    
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        let rc = event.subtype
        println("received remote control \(rc.rawValue)")

        let p = self.curplayer
        switch rc {
        case .RemoteControlTogglePlayPause:
            if p.playing { p.pause() } else { p.doPlay() }
        case .RemoteControlPlay:
            p.doPlay()
        case .RemoteControlPause:
            p.pause()
        default:break
        }
        
    }



}
