

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

extension PHFetchResult: SequenceType {
    public func generate() -> NSFastGenerator {
        return NSFastGenerator(self)
    }
}

class ViewController: UIViewController {
    var albums : PHFetchResult!

    func determineStatus() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .Authorized:
            return true
        case .NotDetermined:
            PHPhotoLibrary.requestAuthorization() {_ in}
            return false
        case .Restricted:
            return false
        case .Denied:
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
            print("not authorized")
            return
        }
        
        let opts = PHFetchOptions()
        let desc = NSSortDescriptor(key: "startDate", ascending: true)
        opts.sortDescriptors = [desc]
        let result = PHCollectionList.fetchCollectionListsWithType(
            .MomentList, subtype: .MomentListYear, options: opts)
        for obj in result {
            let list = obj as! PHCollectionList
            let f = NSDateFormatter()
            f.dateFormat = "yyyy"
            print(f.stringFromDate(list.startDate!))
            // return;
            if list.collectionListType == .MomentList {
                let result = PHAssetCollection.fetchMomentsInMomentList(list, options: nil)
                for (ix,obj) in result.enumerate() {
                    let coll = obj as! PHAssetCollection
                    if ix == 0 {
                        print("======= \(result.count) clusters")
                    }
                    f.dateFormat = ("yyyy-MM-dd")
                    print("starting \(f.stringFromDate(coll.startDate!)): " + "\(coll.estimatedAssetCount)")
                }
            }
            print("\n")
        }
    }

    @IBAction func doButton2(sender: AnyObject) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }

        let result = PHAssetCollection.fetchAssetCollectionsWithType(
            // let's examine albums synced onto the device from iPhoto
            .Album, subtype: .AlbumSyncedAlbum, options: nil)
        for obj in result {
            let album = obj as! PHAssetCollection
            print("\(album.localizedTitle): approximately \(album.estimatedAssetCount) photos")
        }
    }
    
    @IBAction func doButton3(sender: AnyObject) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }

        let alert = UIAlertController(title: "Pick an album:", message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        let result = PHAssetCollection.fetchAssetCollectionsWithType(
            .Album, subtype: .AlbumSyncedAlbum, options: nil)
        for obj in result {
            let album = obj as! PHAssetCollection
            alert.addAction(UIAlertAction(title: album.localizedTitle, style: .Default, handler: {
                (_:UIAlertAction!) in
                let result = PHAsset.fetchAssetsInAssetCollection(album, options: nil)
                for obj in result {
                    let asset = obj as! PHAsset
                    print(asset.localIdentifier)
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
    
    var newAlbumId : String?
    @IBAction func doButton4(sender: AnyObject) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }

        // modification of the library
        // all modifications operate through their own "changeRequest" class
        // so, for example, to create or delete a PHAssetCollection,
        // or to alter what assets it contains,
        // we need a PHAssetCollectionChangeRequest
        // we can use this only inside a PHPhotoLibrary `performChanges` block
        var ph : PHObjectPlaceholder?
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let t = "TestAlbum"
            let cr = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(t)
            ph = cr.placeholderForCreatedAssetCollection
            }, completionHandler: {
                // completion may take some considerable time (asynchronous)
                (ok:Bool, err:NSError?) in
                print("created TestAlbum: \(ok)")
                if let ph = ph {
                    print("and its id is \(ph.localIdentifier)")
                    self.newAlbumId = ph.localIdentifier
                }
        })
    }
    
    @IBAction func doButton5(sender: AnyObject) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }

        let opts = PHFetchOptions()
        opts.wantsIncrementalChangeDetails = false // not used
        // imagine first that we are displaying a list of all regular albums...
        // ... so have performed a fetch request and are hanging on to the result
        let alb = PHAssetCollection.fetchAssetCollectionsWithType(
            .Album, subtype: .AlbumRegular, options: nil)
        self.albums = alb
        // and if we have an observer, it will automatically be sent PHChange messages
        // for this fetch request - if we wanted to prevent that,
        // we would have included the option above
        
        
        // find Recently Added smart album
        let result = PHAssetCollection.fetchAssetCollectionsWithType(
            .SmartAlbum, subtype: .SmartAlbumRecentlyAdded, options: nil)
        guard let rec = result.firstObject as? PHAssetCollection else {
            print("no recently added album")
            return
        }
        // find its first asset
        let result2 = PHAsset.fetchAssetsInAssetCollection(rec, options: nil)
        guard let asset1 = result2.firstObject as? PHAsset else {
            print("no first item in recently added album")
            return
        }
        // find our newly created album by its local id
        let result3 = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([self.newAlbumId!], options: nil)
        guard let alb2 = result3.firstObject as? PHAssetCollection else {
            print("no target album")
            return
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let cr = PHAssetCollectionChangeRequest(forAssetCollection: alb2)
            cr?.addAssets([asset1])
            }, completionHandler: {
                // completion may take some considerable time (asynchronous)
                (ok:Bool, err:NSError?) in
                print("added it: \(ok)")
        })
    }
}

extension ViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(changeInfo: PHChange) {
        print(changeInfo)
        if self.albums !== nil {
            if let details = changeInfo.changeDetailsForFetchResult(self.albums) {
                dispatch_async(dispatch_get_main_queue()) { // NB get on main queue if necessary
                    print("inserted: \(details.insertedObjects)")
                    print("changed: \(details.changedObjects)")
                    self.albums = details.fetchResultAfterChanges
                    // and you can imagine that if we had an interface...
                    // we might change it to reflect these changes
                }
            }
        }
    }
}

