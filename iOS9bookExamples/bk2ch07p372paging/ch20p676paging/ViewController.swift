

import UIKit

class ViewController : UIViewController, UIScrollViewDelegate {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var pager : UIPageControl!
    
    var didLayout = false
    override func viewDidLayoutSubviews() {
        if !self.didLayout {
            self.didLayout = true
            let sz = self.sv.bounds.size
            let colors = [UIColor.redColor(), UIColor.greenColor(), UIColor.yellowColor()]
            for i in 0 ..< 3 {
                let v = UIView(frame:CGRectMake(sz.width*CGFloat(i),0,sz.width,sz.height))
                v.backgroundColor = colors[i]
                self.sv.addSubview(v)
            }
            self.sv.contentSize = CGSizeMake(3*sz.width,sz.height)
        }
    }
    
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        print("begin")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("end")
        let x = self.sv.contentOffset.x
        let w = self.sv.bounds.size.width
        self.pager.currentPage = Int(x/w)
    }
    
    @IBAction func userDidPage(sender:AnyObject?) {
        let p = self.pager.currentPage
        let w = self.sv.bounds.size.width
        self.sv.setContentOffset(CGPointMake(CGFloat(p)*w,0), animated:true)
    }
    
}
