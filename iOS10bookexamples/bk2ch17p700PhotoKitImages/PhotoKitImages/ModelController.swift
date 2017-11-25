

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
        let pred = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        options.predicate = pred
        self.photos = PHAsset.fetchAssets(in:rec, options: options)
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

