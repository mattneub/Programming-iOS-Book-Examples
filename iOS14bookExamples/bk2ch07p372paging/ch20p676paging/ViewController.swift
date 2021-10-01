

import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class ViewController : UIViewController, UIScrollViewDelegate {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var pager : UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pager.currentPageIndicatorTintColor = .systemRed
        self.pager.pageIndicatorTintColor = .systemOrange
        
        
        // self.pager.backgroundColor = .blue
//         self.pager.backgroundStyle = .prominent
//        self.pager.pageIndicatorTintColor = .yellow
//        self.pager.currentPageIndicatorTintColor = .orange
//        self.pager.tintColor = .green // does nothing
//        self.pager.allowsContinuousInteraction = false
//        self.pager.preferredIndicatorImage = UIImage(systemName: "diamond.fill")!
//        self.pager.setIndicatorImage(UIImage(named: "trash")!.withRenderingMode(.alwaysOriginal), forPage: 0)
//        self.pager.numberOfPages = 20
//        print(self.pager.size(forNumberOfPages: 20))
//        print(self.pager.size(forNumberOfPages: 30))
    }
    
    var didLayout = false
    override func viewDidLayoutSubviews() {
        if !self.didLayout {
            self.didLayout = true
            let sz = self.sv.bounds.size
            let colors : [UIColor] = [.red, .green, .yellow]
            for i in 0 ..< 3 {
                let v = UIView(frame:CGRect(sz.width*CGFloat(i),0,sz.width,sz.height))
                v.backgroundColor = colors[i]
                self.sv.addSubview(v)
            }
            self.sv.contentSize = CGSize(3*sz.width,sz.height)
            self.sv.layer.borderWidth = 1 // just so we can see what's really going on
        }
    }
    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("begin")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("end")
        let x = self.sv.contentOffset.x
        let w = self.sv.bounds.size.width
        self.pager.currentPage = Int(x/w)
    }
    
    @IBAction func userDidPage(_ sender: Any?) {
        let p = self.pager.currentPage
        let w = self.sv.bounds.size.width
        self.sv.setContentOffset(CGPoint(CGFloat(p)*w,0), animated:true)
    }
    
}
