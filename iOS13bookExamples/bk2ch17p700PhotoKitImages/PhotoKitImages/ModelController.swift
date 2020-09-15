

import UIKit
import Photos

class ModelController: NSObject {
    
    // uncomment only for sake of book code, not used in real "app"
    // goes with `.smartAlbumRecentlyAdded`
    // var recentAlbums : PHFetchResult<PHAssetCollection>!
    var photos : PHFetchResult<PHAsset>!
    
    func tryToGetStarted() {
        let recentAlbums = PHAssetCollection.fetchAssetCollections(with:
            .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        guard let rec = recentAlbums.firstObject else {return}
        let options = PHFetchOptions()
        let pred = NSPredicate(
            format: "mediaType == %d && !((mediaSubtype & %d) == %d)",
            PHAssetMediaType.image.rawValue,
            PHAssetMediaSubtype.photoHDR.rawValue,
            PHAssetMediaSubtype.photoHDR.rawValue)
        options.predicate = pred // photos only, please, no HDRs
        let sortDesc = NSSortDescriptor(key: #keyPath(PHAsset.creationDate), ascending: false)
        options.sortDescriptors = [sortDesc] // most recent [note that sort is applied before fetching?]
        options.fetchLimit = 10 // let's not take all day about it
        let photos = PHAsset.fetchAssets(in:rec, options: options)
        // self.recentAlbums = recentAlbums
        self.photos = photos
    }

    override init() {
        super.init()
        self.tryToGetStarted()
    }

    func viewController(at ix: Int, storyboard: UIStoryboard) -> DataViewController? {
        if self.photos == nil || self.photos.count == 0 || ix >= self.photos.count {
            return nil
        }
        let dvc = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
        dvc.asset = Optional(self.photos[ix]) // work around compiler crash
        // dvc.index = index
        return dvc
    }
    

    func indexOfViewController(_ dvc: DataViewController) -> Int {
        // return dvc.index
        let ix = self.photos.index(of:dvc.asset)
        return ix
    }
}

extension ModelController : UIPageViewControllerDataSource {

    func pageViewController(_ pvc: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let ix = self.indexOfViewController(viewController as! DataViewController)
        if ix == 0 {
            return nil
        }
        return self.viewController(at:ix-1, storyboard:viewController.storyboard!)
    }

    func pageViewController(_ pvc: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let ix = self.indexOfViewController(viewController as! DataViewController)
        if ix + 1 >= self.photos.count {
            return nil
        }
        return self.viewController(at:ix+1, storyboard:viewController.storyboard!)
    }


}

