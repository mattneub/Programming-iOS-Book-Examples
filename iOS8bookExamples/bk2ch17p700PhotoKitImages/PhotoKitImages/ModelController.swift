

import UIKit
import Photos

extension PHFetchResult: SequenceType {
    public func generate() -> NSFastGenerator {
        return NSFastGenerator(self)
    }
}


class ModelController: NSObject {
    
    var recentAlbums : PHFetchResult!
    var photos : PHFetchResult!
    
    func tryToGetStarted() {
        let result = PHAssetCollection.fetchAssetCollectionsWithType(
            .SmartAlbum, subtype: .SmartAlbumUserLibrary, options: nil)
        self.recentAlbums = result
        let rec = result.firstObject as! PHAssetCollection!
        if rec == nil {
            return
        }
        let options = PHFetchOptions() // photos only, please
        let pred = NSPredicate(format: "mediaType = %@", NSNumber(
            integer:PHAssetMediaType.Image.rawValue))
        options.predicate = pred
        let result2 = PHAsset.fetchAssetsInAssetCollection(rec, options: options)
        self.photos = result2
    }

    override init() {
        super.init()
        self.tryToGetStarted()
    }

    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> DataViewController? {
        if self.photos == nil || self.photos.count == 0 || index >= self.photos.count {
            return nil
        }
        let dvc = storyboard.instantiateViewControllerWithIdentifier("DataViewController") as! DataViewController
        dvc.dataObject = self.photos[index] as! PHAsset
        // dvc.index = index
        return dvc
    }
    

    func indexOfViewController(dvc: DataViewController) -> Int {
        // return dvc.index
        let asset = dvc.dataObject
        let ix = self.photos.indexOfObject(asset)
        return ix
    }
}

extension ModelController : UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let ix = self.indexOfViewController(viewController as! DataViewController)
        if ix == 0 {
            return nil
        }
        return self.viewControllerAtIndex(ix-1, storyboard:viewController.storyboard!)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let ix = self.indexOfViewController(viewController as! DataViewController)
        if ix + 1 >= self.photos.count {
            return nil
        }
        return self.viewControllerAtIndex(ix+1, storyboard:viewController.storyboard!)
    }


}

