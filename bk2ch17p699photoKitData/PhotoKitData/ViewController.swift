

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

//extension PHFetchResult: Sequence {
//    public func makeIterator() -> NSFastEnumerationIterator {
//        return NSFastEnumerationIterator(self)
//    }
//}

class ViewController: UIViewController {
    var albums : PHFetchResult<PHAssetCollection>!

    func determineStatus() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() {_ in}
            return false
        case .restricted:
            return false
        case .denied:
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Photos library?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                _ in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.shared().open(url)
            }))
            self.present(alert, animated:true, completion:nil)
            return false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NSNotificationCenter.default().addObserver(self, selector: #selector(determineStatus), name: UIApplicationWillEnterForegroundNotification, object: nil)
        PHPhotoLibrary.shared().register(self) // *
    }


    @IBAction func doButton(_ sender: AnyObject) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        
        let opts = PHFetchOptions()
        let desc = NSSortDescriptor(key: "startDate", ascending: true)
        opts.sortDescriptors = [desc]
        let result = PHCollectionList.fetchCollectionLists(with:
            .momentList, subtype: .momentListYear, options: opts)
        for ix in 0..<result.count {
            let list = result.object(at:ix)
            let f = NSDateFormatter()
            f.dateFormat = "yyyy"
            print(f.string(from:list.startDate!))
            // return;
            if list.collectionListType == .momentList {
                let result = PHAssetCollection.fetchMoments(inMomentList:list, options: nil)
                for ix in 0 ..< result.count {
                    let coll = result.object(at:ix)
                    if ix == 0 {
                        print("======= \(result.count) clusters")
                    }
                    f.dateFormat = ("yyyy-MM-dd")
                    print("starting \(f.string(from:coll.startDate!)): " + "\(coll.estimatedAssetCount)")
                }
            }
            print("\n")
        }
    }

    @IBAction func doButton2(_ sender: AnyObject) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }

        let result = PHAssetCollection.fetchAssetCollections(with:
            // let's examine albums synced onto the device from iPhoto
            .album, subtype: .albumSyncedAlbum, options: nil)
        for ix in 0 ..< result.count {
            let album = result.object(at:ix)
            print("\(album.localizedTitle): approximately \(album.estimatedAssetCount) photos")
        }
    }
    
    @IBAction func doButton3(_ sender: AnyObject) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }

        let alert = UIAlertController(title: "Pick an album:", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let result = PHAssetCollection.fetchAssetCollections(with:
            .album, subtype: .albumSyncedAlbum, options: nil)
        for ix in 0 ..< result.count {
            let album = result.object(at:ix)
            alert.addAction(UIAlertAction(title: album.localizedTitle, style: .default, handler: {
                (_:UIAlertAction!) in
                let result = PHAsset.fetchAssets(in:album, options: nil)
                for ix in 0 ..< result.count {
                    let asset = result.object(at:ix)
                    print(asset.localIdentifier)
                }
            }))
        }
        self.present(alert, animated: true, completion: nil)
        if let pop = alert.popoverPresentationController {
            if let v = sender as? UIView {
                pop.sourceView = v
                pop.sourceRect = v.bounds
            }
        }
    }
    
    var newAlbumId : String?
    @IBAction func doButton4(_ sender: AnyObject) {
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
        PHPhotoLibrary.shared().performChanges({
            let t = "TestAlbum"
            let cr = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle:t)
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
    
    @IBAction func doButton5(_ sender: AnyObject) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }

        let opts = PHFetchOptions()
        opts.wantsIncrementalChangeDetails = false // not used
        // imagine first that we are displaying a list of all regular albums...
        // ... so have performed a fetch request and are hanging on to the result
        let alb = PHAssetCollection.fetchAssetCollections(with:
            .album, subtype: .albumRegular, options: nil)
        self.albums = alb
        // and if we have an observer, it will automatically be sent PHChange messages
        // for this fetch request - if we wanted to prevent that,
        // we would have included the option above
        
        
        // find Recently Added smart album
        let result = PHAssetCollection.fetchAssetCollections(with:
            .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: nil)
        guard let rec = result.firstObject else {
            print("no recently added album")
            return
        }
        // find its first asset
        let result2 = PHAsset.fetchAssets(in:rec, options: nil)
        guard let asset1 = result2.firstObject else {
            print("no first item in recently added album")
            return
        }
        // find our newly created album by its local id
        let result3 = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [self.newAlbumId!], options: nil)
        guard let alb2 = result3.firstObject else {
            print("no target album")
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let cr = PHAssetCollectionChangeRequest(for: alb2)
            cr?.addAssets([asset1])
            }, completionHandler: {
                // completion may take some considerable time (asynchronous)
                (ok:Bool, err:NSError?) in
                print("added it: \(ok)")
        })
    }
}

// but this cannot compile because generics are not covariant

extension ViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInfo: PHChange) {
        print(changeInfo)
        if self.albums !== nil {
            if let details = changeInfo.changeDetails(for:unsafeBitCast(self.albums, to: PHFetchResult<AnyObject>.self)) {
                dispatch_async(dispatch_get_main_queue()) { // NB get on main queue if necessary
                    print("inserted: \(details.insertedObjects)")
                    print("changed: \(details.changedObjects)")
                    self.albums = unsafeBitCast(details.fetchResultAfterChanges, to: PHFetchResult<PHAssetCollection>.self)
                    // and you can imagine that if we had an interface...
                    // we might change it to reflect these changes
                }
            }
        }
    }
}

