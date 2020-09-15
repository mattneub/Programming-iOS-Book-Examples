

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

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



class ViewController: UIViewController {
    
    @IBOutlet var seg : UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // no need to play with animation in iOS 13; the change is animated by default
        //self.seg.layer.speed = 0.2
        delay(1) {
            self.seg.selectedSegmentIndex = 1
            return;
            self.seg.selectedSegmentIndex = UISegmentedControl.noSegment // no visible effect
            print(self.seg.selectedSegmentIndex) // -1, i.e. no segment
            self.seg.setNeedsLayout() // aha
        }
        
        // in iOS 13, this is painted in a new way
        // the tint color does not affect the text or the border or anything
        // there is a selected segment tint color that is ...
        // the background of the new sliding round rect
//        self.seg.tintColor = .red
//        if #available(iOS 13.0, *) {
//            // self.seg.selectedSegmentTintColor = .green
//        }
//        // self.seg.isMomentary = true
//        self.seg.setEnabled(false, forSegmentAt: 2)
        // return
        
        // background, set desired height but make width resizable
        // sufficient to set for Normal only
        
        let sz = CGSize(100,60)
        let linen = UIImage(named:"linen")!
        let im = UIGraphicsImageRenderer(size:sz).image {_ in
            linen.draw(in:CGRect(origin: .zero, size: sz))
            }.resizableImage(withCapInsets:
                UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10), resizingMode: .stretch)
        self.seg.setBackgroundImage(im, for:.normal, barMetrics: .default)
        // okay but in iOS 13 it is NOT sufficient to set for Normal only
        let im2 = UIGraphicsImageRenderer(size:sz).image {ctx in
            let r = CGRect(origin: .zero, size: sz)
            ctx.cgContext.setFillColor(UIColor.blue.withAlphaComponent(0.1).cgColor)
            ctx.cgContext.fill(r)
            linen.draw(in: r, blendMode: .destinationAtop, alpha: 1)
            }.resizableImage(withCapInsets:
                UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10), resizingMode: .stretch)
        self.seg.setBackgroundImage(im2, for:.selected, barMetrics: .default)
        
        // segment images, redraw at final size
        let pep = ["manny", "moe", "jack"]
        for (i, boy) in pep.enumerated() {
            let sz = CGSize(30,30)
            let im = UIGraphicsImageRenderer(size:sz).image {_ in
                UIImage(named:boy)!.draw(in:CGRect(origin: .zero, size: sz))
                }.withRenderingMode(.alwaysOriginal)
            self.seg.setImage(im, forSegmentAt: i)
            self.seg.setWidth(80, forSegmentAt: i)
        }
        
        // divider, set at desired width, sufficient to set for Normal only
        let sz2 = CGSize(2,10)
        let div = UIGraphicsImageRenderer(size:sz2).image { ctx in
            UIColor.white.set()
            ctx.fill(CGRect(origin: .zero, size: sz2))
        }
        self.seg.setDividerImage(div, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        let seg = UISegmentedControl(
            items: [
                UIImage(named:"smiley")!.withRenderingMode(.alwaysOriginal),
                "Two"
            ])
        seg.tintColor = .red // no effect in iOS 13
        if #available(iOS 13.0, *) {
            // this works in iOS 13 to tint the image
            seg.setImage(UIImage(named:"smiley")!
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.green),
                         forSegmentAt: 0)
            print(seg.tintColor == .red) // true but so what?
        }
        // yay, keys work
        seg.setTitleTextAttributes([
            .foregroundColor: UIColor.blue // this works in iOS 13 to color the text
            // whoa! more than that, it is the default tint color for template images too!!!!!!!!
        ], for: .normal)

        seg.frame.origin = CGPoint(40,100)
        seg.frame.size.width = 200
        //seg.setWidth(0, forSegmentAt: 0)
        seg.apportionsSegmentWidthsByContent = true
        seg.sizeToFit()
        self.view.addSubview(seg)
        return;
        seg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seg.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300),
            seg.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            seg.heightAnchor.constraint(equalToConstant: UIImage(named:"smiley")!.size.height)
            ])
    }
    
    @IBAction func didSelect(_ sender:UISegmentedControl) {
        delay(0.1) {
            print("select", sender.selectedSegmentIndex)
        }
    }
}
