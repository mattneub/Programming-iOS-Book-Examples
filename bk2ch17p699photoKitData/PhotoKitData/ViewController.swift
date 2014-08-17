

import UIKit
import Photos

class ViewController: UIViewController {
    var status = PHAuthorizationStatus.NotDetermined

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // access permission dialog will appear automatically if necessary...
        // ...when we try to present the UIImagePickerController
        // however, things then proceed asynchronously
        // so it can look better to try to ascertain permission in advance
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .NotDetermined:
            PHPhotoLibrary.requestAuthorization({
                status in
                self.status = status
            })
        default:
            self.status = status
        }
    }

    @IBAction func doButton(sender: AnyObject) {
        if self.status != .Authorized {
            println("not authorized")
            return
        }

        
        let opts = PHFetchOptions()
        let desc = NSSortDescriptor(key: "startDate", ascending: true)
        opts.sortDescriptors = [desc]
        let result = PHCollectionList.fetchCollectionListsWithType(
            .MomentList, subtype: .MomentListYear, options: opts)
        result.enumerateObjectsUsingBlock {
            (obj:AnyObject!, ix:Int, stop:UnsafeMutablePointer<ObjCBool>) -> () in
            let list = obj as PHCollectionList
            if list.collectionListType == .MomentList {
                let result = PHAssetCollection.fetchMomentsInMomentList(list, options: nil)
                result.enumerateObjectsUsingBlock {
                    (obj:AnyObject!, ix:Int, stop:UnsafeMutablePointer<ObjCBool>) -> () in
                    let coll = obj as PHAssetCollection
                    if ix == 0 {
                        println("======= \(result.count) collections starting \(list.startDate)")
                    }
                    println("starting \(coll.startDate)")
                }
            }
        }
    }

    @IBAction func doButton2(sender: AnyObject) {
        if self.status != .Authorized {
            println("not authorized")
            return
        }

        let result = PHAssetCollection.fetchAssetCollectionsWithType(
            // let's examine albums synced onto the device from iPhoto
            .Album, subtype: .AlbumSyncedAlbum, options: nil)
        result.enumerateObjectsUsingBlock {
            (obj:AnyObject!, ix:Int, stop:UnsafeMutablePointer<ObjCBool>) -> () in
            let album = obj as PHAssetCollection
            println("\(album.localizedTitle): approximately \(album.estimatedAssetCount) photos")
        }
    }
    
    @IBAction func doButton3(sender: AnyObject) {
        if self.status != .Authorized {
            println("not authorized")
            return
        }

        let alert = UIAlertController(title: "Pick an album:", message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        let result = PHAssetCollection.fetchAssetCollectionsWithType(
            // let's examine albums synced onto the device from iPhoto
            .Album, subtype: .AlbumSyncedAlbum, options: nil)
        result.enumerateObjectsUsingBlock {
            (obj:AnyObject!, ix:Int, stop:UnsafeMutablePointer<ObjCBool>) -> () in
            let album = obj as PHAssetCollection
            alert.addAction(UIAlertAction(title: album.localizedTitle, style: .Default, handler: {
                (_:UIAlertAction!) in
                let result = PHAsset.fetchAssetsInAssetCollection(album, options: nil)
                result.enumerateObjectsUsingBlock {
                    (obj:AnyObject!, ix:Int, stop:UnsafeMutablePointer<ObjCBool>) -> () in
                    let asset = obj as PHAsset
                    println(asset)
                }
            }))
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func doButton4(sender: AnyObject) {
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
                println(ok)
        })
    }
    
    @IBAction func doButton5(sender: AnyObject) {
        // find Recently Added smart-album
        // add first photo from it to a new album
        let result = PHAssetCollection.fetchAssetCollectionsWithType(
            // let's examine albums synced onto the device from iPhoto
            .SmartAlbum, subtype: .SmartAlbumRecentlyAdded, options: nil)
        let rec = result.firstObject as PHAssetCollection!
        if rec == nil {
            return
        }
        let result2 = PHAsset.fetchAssetsInAssetCollection(rec, options: nil)
        let ph = result2.firstObject as PHAsset!
        if ph == nil {
            return
        }
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let t = "My Cool Album"
            let creat = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(t)
            creat.addAssets([ph])
            }, completionHandler: {
                // completion may take some considerable time (asynchronous)
                (ok:Bool, err:NSError!) in
                println(ok)
        })
    }
}

