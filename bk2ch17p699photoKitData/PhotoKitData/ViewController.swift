

import UIKit
import Photos
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController: UIViewController {
    var albums : PHFetchResult!

    func determineStatus() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .Authorized:
            return true
        case .NotDetermined:
            PHPhotoLibrary.requestAuthorization(nil)
            return false
        case .Restricted:
            return false
        case .Denied:
            // new iOS 8 feature: sane way of getting the user directly to the relevant prefs
            // I think the crash-in-background issue is now gone
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Photos library?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                _ in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.sharedApplication().openURL(url)
            }))
            self.presentViewController(alert, animated:true, completion:nil)
            return false
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "determineStatus", name: UIApplicationWillEnterForegroundNotification, object: nil)
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self) // *
    }


    @IBAction func doButton(sender: AnyObject) {
        if !self.determineStatus() {
            println("not authorized")
            return
        }
        
        let opts = PHFetchOptions()
        let desc = NSSortDescriptor(key: "startDate", ascending: true)
        opts.sortDescriptors = [desc]
        let result = PHCollectionList.fetchCollectionListsWithType(
            .MomentList, subtype: .MomentListYear, options: opts)
        result.enumerateObjectsUsingBlock {
            (obj:AnyObject!, ix:Int, stop:UnsafeMutablePointer<ObjCBool>) in
            let list = obj as! PHCollectionList
            let f = NSDateFormatter()
            f.dateFormat = "\nyyyy"
            println(f.stringFromDate(list.startDate))
            if list.collectionListType == .MomentList {
                let result = PHAssetCollection.fetchMomentsInMomentList(list, options: nil)
                result.enumerateObjectsUsingBlock {
                    (obj:AnyObject!, ix:Int, stop:UnsafeMutablePointer<ObjCBool>) in
                    let coll = obj as! PHAssetCollection
                    if ix == 0 {
                        println("======= \(result.count) clusters")
                    }
                    f.dateFormat = ("yyyy-MM-dd")
                    println("starting \(f.stringFromDate(coll.startDate)): " + "\(coll.estimatedAssetCount)")
                }
            }
        }
    }

    @IBAction func doButton2(sender: AnyObject) {
        if !self.determineStatus() {
            println("not authorized")
            return
        }

        let result = PHAssetCollection.fetchAssetCollectionsWithType(
            // let's examine albums synced onto the device from iPhoto
            .Album, subtype: .AlbumSyncedAlbum, options: nil)
        result.enumerateObjectsUsingBlock {
            (obj:AnyObject!, ix:Int, stop:UnsafeMutablePointer<ObjCBool>) in
            let album = obj as! PHAssetCollection
            println("\(album.localizedTitle): approximately \(album.estimatedAssetCount) photos")
        }
    }
    
    @IBAction func doButton3(sender: AnyObject) {
        if !self.determineStatus() {
            println("not authorized")
            return
        }

        let alert = UIAlertController(title: "Pick an album:", message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        let result = PHAssetCollection.fetchAssetCollectionsWithType(
            .Album, subtype: .AlbumSyncedAlbum, options: nil)
        result.enumerateObjectsUsingBlock {
            (obj:AnyObject!, ix:Int, stop:UnsafeMutablePointer<ObjCBool>) in
            let album = obj as! PHAssetCollection
            alert.addAction(UIAlertAction(title: album.localizedTitle, style: .Default, handler: {
                (_:UIAlertAction!) in
                let result = PHAsset.fetchAssetsInAssetCollection(album, options: nil)
                result.enumerateObjectsUsingBlock {
                    (obj:AnyObject!, ix:Int, stop:UnsafeMutablePointer<ObjCBool>) in
                    let asset = obj as! PHAsset
                    println(asset)
                }
            }))
        }
        self.presentViewController(alert, animated: true, completion: nil)
        if let pop = alert.popoverPresentationController {
            if let v = sender as? UIView {
                pop.sourceView = v
                pop.sourceRect = v.bounds
            }
        }
    }
    
    @IBAction func doButton4(sender: AnyObject) {
        if !self.determineStatus() {
            println("not authorized")
            return
        }

        // modification of the library
        // all modifications operate through their own "changeRequest" class
        // so, for example, to create or delete a PHAssetCollection,
        // or to alter what assets it contains,
        // we need a PHAssetCollectionChangeRequest
        // we can use this only inside a PHPhotoLibrary `performChanges` block
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let t = "TestAlbum"
            let creat = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(t)
            }, completionHandler: {
                // completion may take some considerable time (asynchronous)
                (ok:Bool, err:NSError!) in
                println("created TestAlbum: \(ok)")
        })
    }
    
    @IBAction func doButton5(sender: AnyObject) {
        if !self.determineStatus() {
            println("not authorized")
            return
        }

        let opts = PHFetchOptions()
        opts.wantsIncrementalChangeDetails = false // not used
        // imagine first that we are displaying a list of all regular albums...
        // ... so have performed a fetch request and are hanging on to the result
        self.albums = PHAssetCollection.fetchAssetCollectionsWithType(
            .Album, subtype: .AlbumRegular, options: nil)
        // and if we have an observer, it will automatically be sent PHChange messages
        // for this fetch request - if we wanted to prevent that,
        // we would have included the option above

        
        // find Recently Added smart-album
        // add first photo from it to a new album
        let result = PHAssetCollection.fetchAssetCollectionsWithType(
            .SmartAlbum, subtype: .SmartAlbumRecentlyAdded, options: nil)
        let rec = result.firstObject as! PHAssetCollection!
        if rec == nil {
            println("no recently added album")
            return
        }
        let result2 = PHAsset.fetchAssetsInAssetCollection(rec, options: nil)
        let ph = result2.firstObject as! PHAsset!
        if ph == nil {
            println("no first item in recently added album")
            return
        }
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let t = "My Cool Album"
            let creat = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(t)
            creat.addAssets([ph])
            }, completionHandler: {
                // completion may take some considerable time (asynchronous)
                (ok:Bool, err:NSError!) in
                println("created My Cool Album: \(ok)")
        })
    }
}

extension ViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(changeInfo: PHChange!) {
        println(changeInfo)
        if self.albums !== nil {
            if let details = changeInfo.changeDetailsForFetchResult(self.albums) {
                dispatch_async(dispatch_get_main_queue()) { // NB get on main queue if necessary
                    println("inserted: \(details.insertedObjects)")
                    println("changed: \(details.changedObjects)")
                    self.albums = details.fetchResultAfterChanges
                    // and you can imagine that if we had an interface...
                    // we might change it to reflect these changes
                }
            }
        }
    }
}

