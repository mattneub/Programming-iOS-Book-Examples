
// example of a gestureRecognizerShouldBegin situation
// tap gesture recognizer in the background...
// screws up cell selection by tap in the table view

import UIKit

extension UIView {
    func isDescendant(of whattype:UIView.Type) -> Bool {
        var sup : UIView? = self.superview
        while sup != nil {
            if (whattype == type(of:sup!)) { // argh, can't say "is" here
                return true
            }
            sup = sup!.superview
        }
        return false
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let t = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(t)
        t.delegate = self
    }
    
    @objc func tap(_:UIGestureRecognizer) {
        print("tap")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select")
    }
    
    func gestureRecognizerShouldBegin(_ gr: UIGestureRecognizer) -> Bool {
        if let v = gr.view {
            let loc = gr.location(in: v)
            if let v2 = v.hitTest(loc, with: nil) {
                return !v2.isDescendant(of: UICollectionViewCell.self)
            }
        }
        return true
    }

}



