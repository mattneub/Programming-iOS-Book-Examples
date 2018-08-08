
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


class RootViewController: UIViewController {
                            
    var pvc: UIPageViewController?
    var modelController : ModelController!

    override func viewDidLoad() {
        super.viewDidLoad()
        checkForPhotoLibraryAccess(andThen: self.setUpInterface)
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.determineStatus()
//        NotificationCenter.default.addObserver(self, selector: #selector(determineStatus), name: .UIApplicationWillEnterForeground, object: nil)
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
    
    func tryToAddInitialPage() {
        self.modelController = ModelController()
        if let dvc = self.modelController.viewController(at:0, storyboard: self.storyboard!) {
            let viewControllers = [dvc]
            self.pvc!.setViewControllers(viewControllers, direction: .forward, animated: false)
            self.pvc!.dataSource = self.modelController
        }
    }
    
    func setUpInterface() {
        self.pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.pvc!.dataSource = nil
        self.tryToAddInitialPage() // if succeeds, will set data source for real
        
        self.addChild(self.pvc!)
        self.view.addSubview(self.pvc!.view)
        self.pvc!.view.frame = self.view.bounds
        self.pvc!.didMove(toParent: self)
    }
}

// just testing syntax, uncomment to test
/*

extension RootViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInfo: PHChange) {
        if let ci = changeInfo.changeDetails(for:self.modelController.recentAlbums) {
            // if what just happened is: we went from nil to results (because user granted permission)...
            // then start over
            let oldResult = ci.fetchResultBeforeChanges
            if oldResult.firstObject == nil {
                let newResult = ci.fetchResultAfterChanges
                if newResult.firstObject != nil {
                    DispatchQueue.main.async {
                        self.tryToAddInitialPage()
                    }
                }
            }
        }
    }
}
 
 */

extension RootViewController {
    @IBAction func doVignetteButton(_ sender: Any) {

        if let dvc = self.pvc?.viewControllers?[0] as? DataViewController {
            dvc.doVignette()
        }
    }
}


