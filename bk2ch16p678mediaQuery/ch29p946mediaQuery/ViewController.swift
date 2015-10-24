

import UIKit
import MediaPlayer

func imageOfSize(size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

/*
NB New in iOS 7, MPMediaItem properties can be access directly
But I never got the memo, so I'm behind on this change!
Thus we can eliminate the use of valueForProperty throughout
*/



class ViewController: UIViewController {
    
    var q : MPMediaItemCollection!
    @IBOutlet var label : UILabel!
    var timer : NSTimer!
    @IBOutlet var prog : UIProgressView!
    @IBOutlet var vv : MPVolumeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let sz = CGSizeMake(20,20)
        UIGraphicsBeginImageContextWithOptions(
            CGSizeMake(sz.height,sz.height), false, 0)
        UIColor.blackColor().setFill()
        UIBezierPath(ovalInRect:
            CGRectMake(0,0,sz.height,sz.height)).fill()
        let im1 = UIGraphicsGetImageFromCurrentImageContext()
        UIColor.redColor().setFill()
        UIBezierPath(ovalInRect:
            CGRectMake(0,0,sz.height,sz.height)).fill()
        let im2 = UIGraphicsGetImageFromCurrentImageContext()
        UIColor.orangeColor().setFill()
        UIBezierPath(ovalInRect:
            CGRectMake(0,0,sz.height,sz.height)).fill()
        let im3 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.vv.setMinimumVolumeSliderImage(
            im1.resizableImageWithCapInsets(UIEdgeInsetsMake(9,9,9,9),
                resizingMode:.Stretch),
            forState:.Normal)
        self.vv.setMaximumVolumeSliderImage(
            im2.resizableImageWithCapInsets(UIEdgeInsetsMake(9,9,9,9),
                resizingMode:.Stretch),
            forState:.Normal)
        // only for EU devices; to test, use the EU switch under Developer settings on device
        self.vv.volumeWarningSliderImage =
            im3.resizableImageWithCapInsets(UIEdgeInsetsMake(9,9,9,9),
                resizingMode:.Stretch)
        
        let sz2 = CGSizeMake(40,40)
        let thumb = imageOfSize(sz2) {
            UIImage(named:"SmileyRound.png")!.drawInRect(CGRectMake(0,0,sz2.width,sz2.height))
        }
        self.vv.setVolumeThumbImage(thumb, forState:.Normal)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"wirelessChanged:",
            name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification,
            object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"wirelessChanged2:",
            name:MPVolumeViewWirelessRouteActiveDidChangeNotification,
            object:nil)
        
    }
    
    func wirelessChanged(n:NSNotification) {
        print("wireless change \(n.userInfo)")
    }
    func wirelessChanged2(n:NSNotification) {
        print("wireless active change \(n.userInfo)")
    }
    
    @IBAction func doAllAlbumTitles (sender:AnyObject!) {
        do {
            let query = MPMediaQuery() // just making sure this is legal
            let result = query.items
            _ = result
        }
        let query = MPMediaQuery.albumsQuery()
        guard let result = query.collections else {return} //
        // prove we've performed the query, by logging the album titles
        for album in result {
            print(album.representativeItem!.albumTitle!) //
        }
        return; // testing
        // cloud item values are 0 and 1, meaning false and true
        for album in result {
            for song in album.items { //
                print("\(song.cloudItem) \(song.assetURL) \(song.title)")
            }
        }
    }
    
    @IBAction func doBeethovenAlbumTitles (sender:AnyObject!) {
        let query = MPMediaQuery.albumsQuery()
        let hasBeethoven = MPMediaPropertyPredicate(value:"Beethoven",
            forProperty:MPMediaItemPropertyAlbumTitle,
            comparisonType:.Contains)
        query.addFilterPredicate(hasBeethoven)
        guard let result = query.collections else {return} //
        for album in result {
            print(album.representativeItem!.albumTitle!) //
        }
    }
    
    @IBAction func doSonataAlbumsOnDevice (sender:AnyObject!) {
        let query = MPMediaQuery.albumsQuery()
        let hasSonata = MPMediaPropertyPredicate(value:"Sonata",
            forProperty:MPMediaItemPropertyTitle,
            comparisonType:.Contains)
        query.addFilterPredicate(hasSonata)
        let isPresent = MPMediaPropertyPredicate(value:false,
            forProperty:MPMediaItemPropertyIsCloudItem, // string name of property incorrect in header
            comparisonType:.EqualTo)
        query.addFilterPredicate(isPresent)
        
        guard let result = query.collections else {return} //
        for album in result {
            print(album.representativeItem!.albumTitle!)
        }
        // and here are the songs in the first of those albums
        let album = result[0]
        for song in album.items { //
            print(song.title!)
        }
    }
    
    @IBAction func doPlayShortSongs (sender:AnyObject!) {
        let query = MPMediaQuery.songsQuery()
        // always need to filter out songs that aren't present
        let isPresent = MPMediaPropertyPredicate(value:false,
            forProperty:MPMediaItemPropertyIsCloudItem,
            comparisonType:.EqualTo)
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
        player.setQueueWithItemCollection(queue)
        player.shuffleMode = .Songs
        player.beginGeneratingPlaybackNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changed:", name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: player)
        self.q = queue // retain a pointer to the queue
        player.play()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
    }
    
    func changed(n:NSNotification) {
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
        guard let item = player.nowPlayingItem where player.playbackState != .Stopped else {
            self.prog.hidden = true
            return
        } //
        self.prog.hidden = false
        let current = player.currentPlaybackTime
        let total = item.playbackDuration
        self.prog.progress = Float(current / total)
    }

    
}

class MyVolumeView : MPVolumeView {

    
    override func volumeSliderRectForBounds(bounds: CGRect) -> CGRect {
        print(bounds)
        return super.volumeSliderRectForBounds(bounds)
    }
    
    override func volumeThumbRectForBounds(bounds: CGRect, volumeSliderRect rect: CGRect, value: Float) -> CGRect {
        print(value)
        return super.volumeThumbRectForBounds(bounds, volumeSliderRect: rect, value: value)
    }

}

