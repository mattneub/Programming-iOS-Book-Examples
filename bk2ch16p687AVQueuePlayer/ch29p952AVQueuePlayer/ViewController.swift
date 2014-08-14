

import UIKit
import MediaPlayer
import AVFoundation
import CoreMedia

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
        return query.items[0].valueForProperty(MPMediaItemPropertyAssetURL) as NSURL
    }
    
    @IBAction func doPlayOneSongAVAudioPlayer (sender:AnyObject!) {
        let url = self.oneSong()
        self.player.playFileAtURL(url)
        self.curplayer = self.player.player
    }
    
    @IBAction func doPlayOneSongMPMoviePlayerController (sender:AnyObject!) {
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
        let url = self.oneSong()
        self.avplayer = AVPlayer(URL:url)
        self.avplayer.play()
        self.curplayer = self.avplayer
    }
    
    @IBAction func doPlayShortSongs (sender:AnyObject!) {
        let query = MPMediaQuery.songsQuery()
        // always need to filter out songs that aren't present
        let isPresent = MPMediaPropertyPredicate(value:false,
            forProperty:MPMediaItemPropertyIsCloudItem,
            comparisonType:.EqualTo)
        query.addFilterPredicate(isPresent)
        
        let shorties = (query.items as [MPMediaItem]).filter {
            let dur = $0.valueForProperty(MPMediaItemPropertyPlaybackDuration) as NSNumber
            return dur.floatValue < 30
        }
        
        if shorties.count == 0 {
            println("no songs that short!")
            return
        }
        
        self.assets = shorties.map {
            AVPlayerItem(URL: $0.valueForProperty(MPMediaItemPropertyAssetURL) as NSURL)
        }
        
        self.curnum = 0
        self.total = self.assets.count
        
        let seed = min(3,self.assets.count)
        self.qp = AVQueuePlayer(items:Array(self.assets[0..<0+seed]))
        self.assets = Array(self.assets[seed..<self.assets.count])
        
        self.qp.addObserver(self, forKeyPath:"currentItem", options:nil, context:nil)
        self.qp.play()
        self.changed()
        self.curplayer = self.qp
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()

        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
        self.timer.fire()
    }
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<()>) {
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
        var arr = item.asset.commonMetadata
        arr = AVMetadataItem.metadataItemsFromArray(arr,
            withKey:AVMetadataCommonKeyTitle,
            keySpace:AVMetadataKeySpaceCommon)
        let met = arr[0] as AVMetadataItem
        met.loadValuesAsynchronouslyForKeys(["value"]) {
            dispatch_async(dispatch_get_main_queue()) {
                self.label.text = "\(++self.curnum) of \(self.total): \(met.value)"
                MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
                    MPMediaItemPropertyTitle: met.value
                    ]
                }
        }
        if self.assets.count == 0 {
            return
        }
        let newItem = self.assets[0] as AVPlayerItem
        self.qp.insertItem(newItem, afterItem:self.qp.items().last as AVPlayerItem)
        self.assets.removeAtIndex(0)
        
        self.timer?.fire()
    }
    
    func timerFired(sender:AnyObject) {
        if let item = self.qp.currentItem {
            let asset = item.asset
            asset.loadValuesAsynchronouslyForKeys(["duration"]) {
                dispatch_async(dispatch_get_main_queue()) {
                    let cur = self.qp.currentTime()
                    let dur = asset.duration
                    self.prog.progress = Float(CMTimeGetSeconds(cur)/CMTimeGetSeconds(dur))
                    self.prog.hidden = false
                    }
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
    
    override func remoteControlReceivedWithEvent(event: UIEvent!) {
        let rc = event.subtype
        println("received remote control \(rc.toRaw())")

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
