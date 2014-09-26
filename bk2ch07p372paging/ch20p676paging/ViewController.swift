

import UIKit

class ViewController : UIViewController, UIScrollViewDelegate {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var pager : UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sz = self.sv.bounds.size
        let colors = [UIColor.redColor(), UIColor.greenColor(), UIColor.yellowColor()]
        for i in 0 ..< 3 {
            let v = UIView(frame:CGRectMake(sz.width*CGFloat(i),0,sz.width,sz.height))
            v.backgroundColor = colors[i]
            self.sv.addSubview(v)
        }
        self.sv.contentSize = CGSizeMake(3*sz.width,sz.height)
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        println("begin")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("end")
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
