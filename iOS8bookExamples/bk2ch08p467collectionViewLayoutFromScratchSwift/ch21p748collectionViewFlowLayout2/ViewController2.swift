

import UIKit

class ViewController2 : UICollectionViewController {
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.useLayoutToLayoutNavigationTransitions = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "States 2"
        let b = UIBarButtonItem(title:"Flush", style:.Plain, target:self, action:"doFlush:")
        self.navigationItem.rightBarButtonItem = b
        if let flow = self.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.headerReferenceSize = CGSizeMake(50,50)
            flow.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10)
        }
        self.collectionView!.reloadData()
    }
    
    func doFlush (sender:AnyObject) {
        if let layout = self.collectionView!.collectionViewLayout as? MyFlowLayout {
            layout.flush()
        }
    }
    
    // extremely weird transfer of responsibilities
    // I filed a bug on this but Apple insists this is how they want it...
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("\(self.collectionView!.dataSource) \(self.collectionView!.delegate)")
    }
    
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        println("\(self.collectionView!.dataSource) \(self.collectionView!.delegate)")
        delay(2) {
            println("\(self.collectionView!.dataSource) \(self.collectionView!.delegate)")
        }
    }
    
    // but I don't want to be the delegate, because I need the data for that, and I don't have it!
    // (this is what I couldn't get Apple to understand; how can the data source and delegate be different?)
    // so I forward delegation back to the other view controller
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let cv = self.navigationController!.viewControllers[0] as! ViewController
            let result = cv.collectionView(collectionView, layout:collectionViewLayout,
                sizeForItemAtIndexPath:indexPath)
            return result
    }
    
}