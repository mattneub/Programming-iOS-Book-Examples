

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
                DispatchQueue.main.async {
                	f?()
				}
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


// this no longer works because PHFetchResult is now a generic, so I'm forced to enumerate results "by hand"
// seems unfair that PHFetchResult adopts NSFastEnumeration in Objective-C but can't say for...in in Swift

//extension PHFetchResult : Sequence {
//    public func makeIterator() -> NSFastEnumerationIterator {
//        return NSFastEnumerationIterator(self)
//    }
//}

class ViewController: UIViewController {
    var albums : PHFetchResult<PHAssetCollection>!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


    @IBAction func doButton(_ sender: Any) {
        
        checkForPhotoLibraryAccess{
        
            let opts = PHFetchOptions()
            let desc = NSSortDescriptor(key: "startDate", ascending: true)
            opts.sortDescriptors = [desc]
            let result = PHCollectionList.fetchCollectionLists(with:
                .momentList, subtype: .momentListYear, options: opts)
            let lists = result.objects(at: IndexSet(0..<result.count))
            for list in lists {
                let f = DateFormatter()
                f.dateFormat = "yyyy"
                print(f.string(from:list.startDate!))
                // return; // uncomment for first example, years alone
                if list.collectionListType == .momentList {
                    let result = PHAssetCollection.fetchMoments(inMomentList:list, options: nil)
                    let colls = result.objects(at: IndexSet(0..<result.count))
                    for (ix,coll) in colls.enumerated() {
                        if ix == 0 {
                            print("======= \(result.count) clusters")
                        }
                        f.dateFormat = ("yyyy-MM-dd")
                        let count = coll.estimatedAssetCount
                        print("starting \(f.string(from:coll.startDate!)):", count)
                    }
                }
                print("\n")
            }
        }
    }
    
    var which : Int { return 1 }
    var subtype : PHAssetCollectionSubtype {
        switch which {
        case 0: return .albumSyncedAlbum
        case 1: return .albumRegular
        default: return .albumSyncedAlbum
        }
    }

    @IBAction func doButton2(_ sender: Any) {
        
        checkForPhotoLibraryAccess {
            
            let result = PHAssetCollection.fetchAssetCollections(with:
                .album, subtype: self.subtype, options: nil)
            let albums = result.objects(at: IndexSet(0..<result.count))
            for album in albums {
                let count = album.estimatedAssetCount
                print("\(album.localizedTitle!):",
                    "approximately \(count) photos")
            }
            
        }
    }
    
    @IBAction func doButton3(_ sender: Any) {
        
        checkForPhotoLibraryAccess {
            let result = PHAssetCollection.fetchAssetCollections(with:
                .album, subtype: self.subtype, options: nil)
            guard result.count > 0 else { print("no albums"); return }
            let alert = UIAlertController(title: "Pick an album:", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            let albums = result.objects(at: IndexSet(0..<result.count))
            for album in albums {
                alert.addAction(UIAlertAction(title: album.localizedTitle, style: .default) {
                    (_:UIAlertAction!) in
                    let result = PHAsset.fetchAssets(in:album, options: nil)
                    let assets = result.objects(at: IndexSet(0..<result.count))
                    for asset in assets {
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
    
    var newAlbumId : String!
    @IBAction func doButton4(_ sender: Any) {
        
        checkForPhotoLibraryAccess {
            
            var which : Int {return 2}
            
            
            switch which {
            case 1:
                PHPhotoLibrary.shared().performChanges({
                    let t = "TestAlbum"
                    typealias Req = PHAssetCollectionChangeRequest
                    Req.creationRequestForAssetCollection(withTitle:t)
                })

                
            case 2:
                
                var ph : PHObjectPlaceholder?
                PHPhotoLibrary.shared().performChanges({
                    let t = "TestAlbum"
                    typealias Req = PHAssetCollectionChangeRequest
                    let cr = Req.creationRequestForAssetCollection(withTitle:t)
                    ph = cr.placeholderForCreatedAssetCollection
                }) { ok, err in
                    print("created TestAlbum: \(ok)")
                    if ok, let ph = ph {
                        print("and its id is \(ph.localIdentifier)")
                        self.newAlbumId = ph.localIdentifier
                    }
                }

                
            default: break
            }
            
            
        }
    }
    
    @IBAction func doButton5(_ sender: Any) {
        
        checkForPhotoLibraryAccess {
            
            PHPhotoLibrary.shared().register(self) // *

            let opts = PHFetchOptions()
            opts.wantsIncrementalChangeDetails = false
            // use this opts to prevent extra PHChange messages
            
            // imagine first that we are displaying a list of all regular albums...
            // ... so have performed a fetch request and are hanging on to the result
            let alb = PHAssetCollection.fetchAssetCollections(with:
                .album, subtype: .albumRegular, options: nil)
            self.albums = alb
            
            // find Recently Added smart album
            let result = PHAssetCollection.fetchAssetCollections(with:
                .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: opts)
            guard let rec = result.firstObject else {
                print("no recently added album")
                return
            }
            // find its first asset
            let result2 = PHAsset.fetchAssets(in:rec, options: opts)
            guard let asset1 = result2.firstObject else {
                print("no first item in recently added album")
                return
            }
            // find our newly created album by its local id
            let result3 = PHAssetCollection.fetchAssetCollections(
                withLocalIdentifiers: [self.newAlbumId], options: opts)
            guard let alb2 = result3.firstObject else {
                print("no target album")
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                typealias Req = PHAssetCollectionChangeRequest
                let cr = Req(for: alb2)
                cr?.addAssets([asset1] as NSArray)
            })  {
                (ok:Bool, err:Error?) in
                print("added it: \(ok)")
            }
            
        }
    }
}

extension ViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInfo: PHChange) {
        if self.albums !== nil {
            let details = changeInfo.changeDetails(for:self.albums)
            print(details as Any)
            if details !== nil {
                self.albums = details!.fetchResultAfterChanges
                // ... and adjust interface if needed ...
            }
        }
    }
}

