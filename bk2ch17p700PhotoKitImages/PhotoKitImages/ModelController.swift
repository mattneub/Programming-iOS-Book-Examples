

import UIKit
import Photos

class ModelController: NSObject {
    
    var recentAlbums : PHFetchResult<PHAssetCollection>!
    var photos : PHFetchResult<PHAsset>!
    
    func tryToGetStarted() {
        self.recentAlbums = PHAssetCollection.fetchAssetCollections(with:
            .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        guard let rec = self.recentAlbums.firstObject else {return}
        let options = PHFetchOptions() // photos only, please
        let pred = NSPredicate(format: "mediaType = %@", NSNumber(
            value:PHAssetMediaType.image.rawValue))
        options.predicate = pred
        self.photos = PHAsset.fetchAssets(in:rec, options: options)
    }

    override init() {
        super.init()
        self.tryToGetStarted()
    }

    func viewController(at index: Int, storyboard: UIStoryboard) -> DataViewController? {
        if self.photos == nil || self.photos.count == 0 || index >= self.photos.count {
            return nil
        }
        let dvc = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
        dvc.asset = self.photos.object(at:index) // as! PHAsset
        // dvc.index = index
        return dvc
    }
    

    func indexOfViewController(_ dvc: DataViewController) -> Int {
        // return dvc.index
        let asset = dvc.asset
        let ix = self.photos.index(of:asset)
        return ix
    }
}

extension ModelController : UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let ix = self.indexOfViewController(viewController as! DataViewController)
        if ix == 0 {
            return nil
        }
        return self.viewController(at:ix-1, storyboard:viewController.storyboard!)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let ix = self.indexOfViewController(viewController as! DataViewController)
        if ix + 1 >= self.photos.count {
            return nil
        }
        return self.viewController(at:ix+1, storyboard:viewController.storyboard!)
    }


}

