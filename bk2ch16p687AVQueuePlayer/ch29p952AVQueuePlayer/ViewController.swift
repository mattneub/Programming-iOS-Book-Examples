

import UIKit
import MediaPlayer
import AVFoundation
import CoreMedia
import AVKit

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
    var ob : AnyObject!
    @IBOutlet var prog : UIProgressView!
    @IBOutlet var label : UILabel!
    
    var curnum = 0
    var total = 0
    
    var curplayer : PlayerPauser!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func oneSong () -> URL? {
        let query = MPMediaQuery.songs()
        // always need to filter out songs that aren't present
        let isPresent = MPMediaPropertyPredicate(value:false,
            forProperty:MPMediaItemPropertyIsCloudItem,
            comparisonType:.equalTo)
        query.addFilterPredicate(isPresent)
        return query.items?[0].assetURL
    }
    
    @IBAction func doPlayOneSongAVAudioPlayer (_ sender:AnyObject!) {
        self.curplayer?.pause()
        if let url = self.oneSong() {
            self.player.playFile(at:url)
            self.curplayer = self.player.player
        }
    }
    
    @IBAction func doPlayOneSongAVPlayer (_ sender:AnyObject!) {
        self.curplayer?.pause()
        if let url = self.oneSong() {
            self.avplayer = AVPlayer(url:url)
            self.avplayer.play()
            self.curplayer = self.avplayer
        }
    }
    
    @IBAction func doPlayOneSongAVKit(_ sender: AnyObject) {
        self.curplayer?.pause()
        guard let url = self.oneSong() else {return}
        let p = AVPlayer(url:url)
        let vc = AVPlayerViewController()
        vc.player = p
        vc.view.frame = CGRect(20,-5,250,80) // no smaller height or we get constraint issues
        vc.view.backgroundColor = UIColor.clear()
        // cover the black QuickTime background, heh heh
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white()
        vc.contentOverlayView!.addSubview(v)
        let c : [NSLayoutConstraint] = [
            v.leadingAnchor.constraint(equalTo:v.superview!.leadingAnchor),
            v.trailingAnchor.constraint(equalTo:v.superview!.trailingAnchor),
            v.topAnchor.constraint(equalTo:v.superview!.topAnchor),
            v.bottomAnchor.constraint(equalTo:v.superview!.bottomAnchor),
        ]
        NSLayoutConstraint.activate(c)
        let v2 = UIView()
        v2.translatesAutoresizingMaskIntoConstraints = false
        v2.backgroundColor = UIColor.black()
        vc.contentOverlayView!.addSubview(v2)
        let c2 : [NSLayoutConstraint] = [
            v2.leadingAnchor.constraint(equalTo:v2.superview!.leadingAnchor),
            v2.trailingAnchor.constraint(equalTo:v2.superview!.trailingAnchor),
            v2.heightAnchor.constraint(equalToConstant:44),
            v2.bottomAnchor.constraint(equalTo:v2.superview!.bottomAnchor),
        ]
        NSLayoutConstraint.activate(c2)
        
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        p.play()
        self.curplayer = p
    }
    
    @IBAction func doPlayShortSongs (_ sender:AnyObject!) {
        self.curplayer?.pause()
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
                asset: asset, automaticallyLoadedAssetKeys: ["duration"])
            // duration needed later; this way, queue player will load it for us up front
        }
        
        self.curnum = 0
        self.total = self.items.count
        
        if self.ob != nil && self.qp != nil {
            self.qp.removeTimeObserver(self.ob)
        }
        
        let seed = min(3,self.items.count)
        self.qp = AVQueuePlayer(items:Array(self.items.prefix(upTo:seed)))
        self.items = Array(self.items.suffix(from:seed))
        
        // use .Initial option so that we get an observation for the first item
        self.qp.addObserver(self, forKeyPath:"currentItem", options:.initial, context:nil)
        self.qp.play()
        self.curplayer = self.qp
        
        UIApplication.shared().beginReceivingRemoteControlEvents()
        
        self.ob = self.qp.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.5, 600), queue: nil, using: self.timerFired)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
        if keyPath == "currentItem" {
            self.changed()
        }
    }
    
    func changed() {
        guard let item = self.qp.currentItem else {return}
        self.curnum += 1
        var arr = item.asset.commonMetadata
        arr = AVMetadataItem.metadataItems(from:arr,
            withKey:AVMetadataCommonKeyTitle,
            keySpace:AVMetadataKeySpaceCommon)
        let met = arr[0]
        met.loadValuesAsynchronously(forKeys:["value"]) {
            // should always check for successful load of value
            if met.statusOfValue(forKey:"value", error: nil) == .loaded {
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
            if asset.statusOfValue(forKey:"duration", error: nil) == .loaded {
                let dur = asset.duration
                self.prog.setProgress(Float(time.seconds/dur.seconds), animated: false)
                self.prog.isHidden = false
            }
        } else {
            // none of this is executed; I need a way of learning when we are completely done
            // or else I can just forget this feature
            self.label.text = ""
            self.prog.isHidden = true
            self.qp.removeTimeObserver(self.ob)
            self.ob = nil
            print("removing observer")
        }
    }
    
    
    
    // ======== respond to remote controls
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.shared().beginReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        let rc = event!.subtype
        print("received remote control \(rc.rawValue)")
        
        let p = self.curplayer!
        switch rc {
        case .remoteControlTogglePlayPause:
            if p.playing { p.pause() } else { p.doPlay() }
        case .remoteControlPlay:
            p.doPlay()
        case .remoteControlPause:
            p.pause()
        case .remoteControlNextTrack:
            if let p = p as? AVQueuePlayer {
                p.advanceToNextItem()
            }
        default:break
        }
        
    }
    
    
    
}
