

import UIKit

class ViewController2 : UICollectionViewController {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.useLayoutToLayoutNavigationTransitions = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "States 2"
        let b = UIBarButtonItem(title:"Flush", style:.plain, target:self, action:#selector(doFlush))
        self.navigationItem.rightBarButtonItem = b
        if let flow = self.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.headerReferenceSize = CGSize(50,50)
            flow.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        }
        self.collectionView!.reloadData()
    }
    
    @objc func doFlush (_ sender: Any) {
        if let layout = self.collectionView!.collectionViewLayout as? MyFlowLayout {
            layout.flush()
        }
    }
    
    // extremely weird transfer of responsibilities
    // I filed a bug on this but Apple insists this is how they want it...
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // return;
        //print(self, #function)
        //print("layout is \(self.collectionView!.collectionViewLayout)")
        //print("data source is \(self.collectionView!.dataSource)")
        //print("delegate is \(self.collectionView!.delegate)")
    }
    
    override func viewDidAppear(_ animated: Bool)  {
        super.viewDidAppear(animated)
//        print(self, #function)
//        print("layout is \(self.collectionView!.collectionViewLayout)")
//        print("data source is \(self.collectionView!.dataSource)")
//        print("delegate is \(self.collectionView!.delegate)")
        let oldDelegate = self.collectionView!.delegate
        DispatchQueue.main.async {
//            print("right after")
//            print("layout is \(self.collectionView!.collectionViewLayout)")
//            print("data source is \(self.collectionView!.dataSource)")
//            print("delegate is \(self.collectionView!.delegate)")
            self.collectionView!.delegate = oldDelegate
        }
    }
}

/*
extension ViewController2 : UICollectionViewDelegateFlowLayout {
    // but I don't want to be the delegate, because I need the data for that, and I don't have it!
    // (this is what I couldn't get Apple to understand; how can the data source and delegate be different?)
    // so I forward delegation back to the other view controller
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("forwarding to the other view controller")
        let cv = self.navigationController!.viewControllers[0] as! ViewController
        let result = cv.collectionView(collectionView, layout:collectionViewLayout,
                                       sizeForItemAt:indexPath)
        return result
    }
}
 */
