

import UIKit
import Photos

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func checkForPhotoLibraryAccess(andThen f:(()->())? = nil) {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization() { status in
            if status == .authorized {
                f?()
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


// this crashes the compiler, so I'm forced to enumerate results "by hand"
// seems unfair that PHFetchResult adopts NSFastEnumeration in Objective-C but can't say for...in in Swift

//extension PHFetchResult: Sequence {
//    public func makeIterator() -> NSFastEnumerationIterator {
//        return NSFastEnumerationIterator(self)
//    }
//}

class ViewController: UIViewController {
    var albums : PHFetchResult<PHAssetCollection>!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // PHPhotoLibrary.shared().register(self) // *
    }


    @IBAction func doButton(_ sender: Any) {
        
        checkForPhotoLibraryAccess{
        
            let opts = PHFetchOptions()
            let desc = NSSortDescriptor(key: "startDate", ascending: true)
            opts.sortDescriptors = [desc]
            let result = PHCollectionList.fetchCollectionLists(with:
                .momentList, subtype: .momentListYear, options: opts)
            for ix in 0..<result.count {
                let list = result[ix]
                let f = DateFormatter()
                f.dateFormat = "yyyy"
                print(f.string(from:list.startDate!))
                // return;
                if list.collectionListType == .momentList {
                    let result = PHAssetCollection.fetchMoments(inMomentList:list, options: nil)
                    for ix in 0 ..< result.count {
                        let coll = result[ix]
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
    }

    @IBAction func doButton2(_ sender: Any) {
        
        checkForPhotoLibraryAccess {

            let result = PHAssetCollection.fetchAssetCollections(with:
                // let's examine albums synced onto the device from iPhoto
                .album, subtype: .albumSyncedAlbum, options: nil)
            for ix in 0 ..< result.count {
                let album = result[ix]
                print("\(album.localizedTitle): approximately \(album.estimatedAssetCount) photos")
            }
            
        }
    }
    
    @IBAction func doButton3(_ sender: Any) {
        
        checkForPhotoLibraryAccess {

            let alert = UIAlertController(title: "Pick an album:", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            let result = PHAssetCollection.fetchAssetCollections(with:
                .album, subtype: .albumSyncedAlbum, options: nil)
            for ix in 0 ..< result.count {
                let album = result[ix]
                alert.addAction(UIAlertAction(title: album.localizedTitle, style: .default) {
                    (_:UIAlertAction!) in
                    let result = PHAsset.fetchAssets(in:album, options: nil)
                    for ix in 0 ..< result.count {
                        let asset = result[ix]
                        print(asset.localIdentifier)
                    }
                })
            }
            self.present(alert, animated: true)
            if let pop = alert.popoverPresentationController {
                if let v = sender as? UIView {
                    pop.sourceView = v
                    pop.sourceRect = v.bounds
                }
            }
            
        }
    }
    
    var newAlbumId : String?
    @IBAction func doButton4(_ sender: Any) {
        
        checkForPhotoLibraryAccess {

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
                    (ok:Bool, err:Error?) in
                    print("created TestAlbum: \(ok)")
                    if let ph = ph {
                        print("and its id is \(ph.localIdentifier)")
                        self.newAlbumId = ph.localIdentifier
                    }
            })
            
        }
    }
    
    @IBAction func doButton5(_ sender: Any) {
        
        checkForPhotoLibraryAccess {

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
                cr?.addAssets([asset1] as NSArray)
                }, completionHandler: {
                    // completion may take some considerable time (asynchronous)
                    (ok:Bool, err:Error?) in
                    print("added it: \(ok)")
            })
            
        }
    }
}

extension ViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInfo: PHChange) {
        print(changeInfo)
        if self.albums !== nil {
            if let details = changeInfo.changeDetails(for:self.albums) {
                // NB get on main queue if necessary
                DispatchQueue.main.async {
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

