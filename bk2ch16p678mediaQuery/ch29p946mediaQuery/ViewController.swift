

import UIKit
import MediaPlayer

func imageOfSize(_ size:CGSize, closure:() -> ()) -> UIImage {
    let r = UIGraphicsImageRenderer(size:size)
    return r.image {
        _ in closure()
    }
}


/*
NB New in iOS 7, MPMediaItem properties can be access directly
But I never got the memo, so I'm behind on this change!
Thus we can eliminate the use of valueForProperty throughout
*/

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



class ViewController: UIViewController {
    
    var q : MPMediaItemCollection!
    @IBOutlet var label : UILabel!
    var timer : Timer!
    @IBOutlet var prog : UIProgressView!
    @IBOutlet var vv : MPVolumeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let sz = CGSize(20,20)
        let r = UIGraphicsImageRenderer(size:sz)
        let im1 = r.image {
            _ in
            UIColor.black().setFill()
            UIBezierPath(ovalIn:
                CGRect(0,0,sz.height,sz.height)).fill()
        }
        let im2 = r.image {
            _ in
            UIColor.red().setFill()
            UIBezierPath(ovalIn:
                CGRect(0,0,sz.height,sz.height)).fill()
        }
        let im3 = r.image {
            _ in
            UIColor.orange().setFill()
            UIBezierPath(ovalIn:
                CGRect(0,0,sz.height,sz.height)).fill()
        }

        
        
//        UIGraphicsBeginImageContextWithOptions(
//            CGSize(sz.height,sz.height), false, 0)
//        UIColor.black().setFill()
//        UIBezierPath(ovalIn:
//            CGRect(0,0,sz.height,sz.height)).fill()
//        let im1 = UIGraphicsGetImageFromCurrentImageContext()!
//        UIColor.red().setFill()
//        UIBezierPath(ovalIn:
//            CGRect(0,0,sz.height,sz.height)).fill()
//        let im2 = UIGraphicsGetImageFromCurrentImageContext()!
//        UIColor.orange().setFill()
//        UIBezierPath(ovalIn:
//            CGRect(0,0,sz.height,sz.height)).fill()
//        let im3 = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        self.vv.setMinimumVolumeSliderImage(
            im1.resizableImage(withCapInsets:UIEdgeInsetsMake(9,9,9,9),
                resizingMode:.stretch),
            for:[])
        self.vv.setMaximumVolumeSliderImage(
            im2.resizableImage(withCapInsets:UIEdgeInsetsMake(9,9,9,9),
                resizingMode:.stretch),
            for:[])
        // only for EU devices; to test, use the EU switch under Developer settings on device
        self.vv.volumeWarningSliderImage =
            im3.resizableImage(withCapInsets:UIEdgeInsetsMake(9,9,9,9),
                resizingMode:.stretch)
        
        let sz2 = CGSize(40,40)
        let thumb = imageOfSize(sz2) {
            UIImage(named:"SmileyRound.png")!.draw(in:CGRect(0,0,sz2.width,sz2.height))
        }
        self.vv.setVolumeThumbImage(thumb, for:[])
        
        
        NotificationCenter.default().addObserver(self, selector:#selector(wirelessChanged),
            name:Notification.Name.MPVolumeViewWirelessRoutesAvailableDidChange,
            object:nil)
        NotificationCenter.default().addObserver(self,
            selector:#selector(wirelessChanged2),
            name:Notification.Name.MPVolumeViewWirelessRouteActiveDidChange,
            object:nil)
        
    }
    
    func wirelessChanged(_ n:NSNotification) {
        print("wireless change \(n.userInfo)")
    }
    func wirelessChanged2(_ n:NSNotification) {
        print("wireless active change \(n.userInfo)")
    }
    
    @IBAction func doAllAlbumTitles (_ sender:AnyObject!) {
        do {
            let query = MPMediaQuery() // just making sure this is legal
            let result = query.items
            _ = result
        }
        let query = MPMediaQuery.albums()
        guard let result = query.collections else {return} //
        // prove we've performed the query, by logging the album titles
        for album in result {
            print(album.representativeItem!.albumTitle!) //
        }
        return; // testing
        // cloud item values are 0 and 1, meaning false and true
        for album in result {
            for song in album.items { //
                print("\(song.isCloudItem) \(song.assetURL) \(song.title)")
            }
        }
    }
    
    @IBAction func doBeethovenAlbumTitles (_ sender:AnyObject!) {
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
    
    @IBAction func doSonataAlbumsOnDevice (_ sender:AnyObject!) {
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
    
    @IBAction func doPlayShortSongs (_ sender:AnyObject!) {
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
        let player = MPMusicPlayerController.applicationMusicPlayer()
        player.stop()
        player.setQueue(with:queue)
        player.shuffleMode = .songs
        player.beginGeneratingPlaybackNotifications()
        NotificationCenter.default().addObserver(self, selector: #selector(changed), name: Notification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        self.q = queue // retain a pointer to the queue
        player.play()
        
        self.timer = Timer.scheduledTimer(timeInterval:1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
    }
    
    func changed(_ n:NSNotification) {
        defer {
            self.timer?.fire() // looks better if we fire timer now
        }
        self.label.text = ""
        let player = MPMusicPlayerController.applicationMusicPlayer()
        guard n.object === player else { return } // just playing safe
        guard let title = player.nowPlayingItem?.title else {return}
        let ix = player.indexOfNowPlayingItem
        guard ix != NSNotFound else {return}
        self.label.text = "\(ix+1) of \(self.q.count): \(title)"
    }
    
    func timerFired(_:AnyObject) {
        let player = MPMusicPlayerController.applicationMusicPlayer()
        guard let item = player.nowPlayingItem where player.playbackState != .stopped else {
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
        print(bounds)
        return super.volumeSliderRect(forBounds: bounds)
    }
    
    override func volumeThumbRect(forBounds bounds: CGRect, volumeSliderRect rect: CGRect, value: Float) -> CGRect {
        print(value)
        return super.volumeThumbRect(forBounds: bounds, volumeSliderRect: rect, value: value)
    }

}

